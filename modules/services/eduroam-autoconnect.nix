{ config, lib, pkgs, ... }:

let
  cfg = config.services.eduroam-autoconnect;

  nmcli = "${pkgs.networkmanager}/bin/nmcli";
  coreutils = "${pkgs.coreutils}/bin";
  gawk = "${pkgs.gawk}/bin/awk";
  gnugrep = "${pkgs.gnugrep}/bin/grep";
  utilLinux = "${pkgs.util-linux}/bin";

  script = pkgs.writeShellScript "eduroam-autoconnect" ''
    set -euo pipefail

    SSID="eduroam"
    CONN_FILE="/etc/NetworkManager/system-connections/eduroam.nmconnection"
    UUID_DIR="/var/lib/eduroam-autoconnect"
    UUID_FILE="$UUID_DIR/uuid"
    MODE="''${1:-install}" # install|watch

    get_wifi_dev() {
      ${nmcli} -t -f DEVICE,TYPE device status | ${gawk} -F: '$2=="wifi"{print $1; exit}'
    }

    profile_exists() {
      # True if a connection profile named $SSID exists in NetworkManager
      ${nmcli} -t -f NAME connection show | ${gnugrep} -Fxq "$SSID"
    }

    ssid_visible() {
      local dev="$1"
      # Trigger a scan and check for SSID presence.
      # (We ignore errors here because some drivers block scans while connected.)
      ${nmcli} device wifi rescan ifname "$dev" || true
      ${nmcli} -t -f SSID device wifi list ifname "$dev" | ${gnugrep} -Fxq "$SSID"
    }

    active_conn() {
      local dev="$1"
      ${nmcli} -t -f GENERAL.CONNECTION device show "$dev" | ${gawk} -F: '{print $2}'
    }

    # Prevent overlap between timer ticks / manual runs.
    LOCK="/run/eduroam-autoconnect.lock"
    exec 9>"$LOCK"
    ${utilLinux}/flock -w 5 9 || exit 0

    WIFI_DEV="$(get_wifi_dev || true)"
    if [ -z "''${WIFI_DEV:-}" ]; then
      exit 0
    fi

    if [ "$MODE" = "watch" ]; then
      if [ "${lib.boolToString cfg.enableWatcher}" != "true" ]; then
        exit 0
      fi

      # In watch mode: do NOT rewrite profiles or reload NM.
      # Only switch when the SSID is visible and we're not already on it.
      if ! ssid_visible "$WIFI_DEV"; then
        exit 0
      fi

      ACTIVE="$(active_conn "$WIFI_DEV" || true)"
      if [ "''${ACTIVE:-}" = "$SSID" ]; then
        exit 0
      fi

      # Ensure the profile exists (installed by the profile service).
      if ! profile_exists; then
        echo "eduroam-autoconnect: profile '$SSID' not found; skipping switch" >&2
        exit 0
      fi

      if [ "${lib.boolToString cfg.switchWhenDetected}" = "true" ]; then
        ${nmcli} connection up id "$SSID" ifname "$WIFI_DEV" || true
      fi
      exit 0
    fi

    if [ "$MODE" != "install" ]; then
      echo "eduroam-autoconnect: unknown mode: $MODE (expected install|watch)" >&2
      exit 2
    fi

    : ''${EDUROAM_IDENTITY:?EDUROAM_IDENTITY is required}
    : ''${EDUROAM_PASSWORD_FILE:?EDUROAM_PASSWORD_FILE is required}

    if [ ! -r "$EDUROAM_PASSWORD_FILE" ]; then
      echo "eduroam-autoconnect: password file not readable: $EDUROAM_PASSWORD_FILE" >&2
      exit 1
    fi

    PASSWORD="$(${coreutils}/cat "$EDUROAM_PASSWORD_FILE")"

    ${coreutils}/mkdir -p "$UUID_DIR"
    if [ -r "$UUID_FILE" ]; then
      UUID="$(${coreutils}/cat "$UUID_FILE")"
    else
      UUID="$(${utilLinux}/uuidgen)"
      echo "$UUID" > "$UUID_FILE"
      ${coreutils}/chmod 600 "$UUID_FILE"
    fi

    TMP="$(${coreutils}/mktemp)"
    trap '${coreutils}/rm -f "$TMP"' EXIT

    # Create/refresh the NM profile (root-owned, mode 600). We do this at runtime so the password
    # never enters the Nix store.
    ${coreutils}/cat > "$TMP" <<EOF
[connection]
id=$SSID
uuid=$UUID
type=wifi
autoconnect=true
autoconnect-priority=${toString cfg.autoconnectPriority}

[wifi]
mode=infrastructure
ssid=$SSID

[wifi-security]
key-mgmt=wpa-eap

[802-1x]
eap=peap;
identity=$EDUROAM_IDENTITY
password=$PASSWORD
phase2-auth=mschapv2
${lib.optionalString (cfg.domainSuffixMatch != null) "domain-suffix-match=${cfg.domainSuffixMatch}"}
${lib.optionalString (cfg.caCertPath != null) "ca-cert=${cfg.caCertPath}"}

[ipv4]
method=auto

[ipv6]
method=auto
EOF

    ${coreutils}/install -o root -g root -m 600 "$TMP" "$CONN_FILE"

    # Reload profiles so NM sees changes.
    ${nmcli} connection reload || true

    # One-shot optional connect (boot/login) - only when SSID is visible.
    if [ "${lib.boolToString cfg.attemptConnectNow}" = "true" ]; then
      if ssid_visible "$WIFI_DEV"; then
        ACTIVE="$(active_conn "$WIFI_DEV" || true)"
        if [ "''${ACTIVE:-}" != "$SSID" ]; then
          ${nmcli} connection up id "$SSID" ifname "$WIFI_DEV" || true
        fi
      fi
    fi
  '';
in
{
  options.services.eduroam-autoconnect = {
    enable = lib.mkEnableOption "Auto-connect to eduroam (NetworkManager) using a runtime password file (not stored in Nix store)";

    identity = lib.mkOption {
      type = lib.types.str;
      example = "user@realm.example";
      description = "Eduroam EAP identity (username).";
    };

    passwordFile = lib.mkOption {
      # NOTE: use string (not path) so Nix doesn't copy it into the store.
      type = lib.types.str;
      example = "/etc/nixos/secrets/eduroam.password";
      description = "Absolute path to a root-readable file containing ONLY the eduroam password.";
    };

    enableWatcher = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable a periodic watcher that switches to eduroam when the SSID is visible.";
    };

    watchIntervalSeconds = lib.mkOption {
      type = lib.types.ints.positive;
      default = 30;
      description = "Watcher timer interval in seconds.";
    };

    switchWhenDetected = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If true, the watcher will switch the active Wi-Fi connection to eduroam when it becomes visible.";
    };

    attemptConnectNow = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If true, attempt to bring up the eduroam connection once at boot after installing the profile.";
    };

    autoconnectPriority = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "NetworkManager autoconnect priority for eduroam (higher wins).";
    };

    # Optional hardening knobs for PEAP server validation.
    domainSuffixMatch = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional: set NetworkManager 802.1x domain-suffix-match for server cert validation (recommended when you know the realm).";
    };

    caCertPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional: absolute path to a CA certificate PEM file to validate the eduroam server certificate.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure NM is enabled somewhere (you already do this in modules/system/network.nix).
    networking.networkmanager.enable = lib.mkDefault true;

    systemd.services.eduroam-autoconnect-profile = {
      description = "Install/refresh eduroam NetworkManager profile (password from runtime file)";
      wants = [ "NetworkManager.service" ];
      after = [ "NetworkManager.service" ];
      serviceConfig = {
        Type = "oneshot";
        Environment = [
          "EDUROAM_IDENTITY=${cfg.identity}"
          "EDUROAM_PASSWORD_FILE=${cfg.passwordFile}"
        ];
        ExecStart = "${script} install";
        StandardOutput = "journal";
        StandardError = "journal";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.eduroam-autoconnect-watch = lib.mkIf cfg.enableWatcher {
      description = "Periodically switch/connect to eduroam when detected";
      wants = [ "NetworkManager.service" ];
      after = [ "NetworkManager.service" "eduroam-autoconnect-profile.service" ];
      serviceConfig = {
        Type = "oneshot";
        Environment = [
          "EDUROAM_IDENTITY=${cfg.identity}"
          "EDUROAM_PASSWORD_FILE=${cfg.passwordFile}"
        ];
        ExecStart = "${script} watch";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.timers.eduroam-autoconnect-watch = lib.mkIf cfg.enableWatcher {
      description = "Timer for eduroam auto-connect watcher";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "20s";
        OnUnitActiveSec = "${toString cfg.watchIntervalSeconds}s";
        Unit = "eduroam-autoconnect-watch.service";
      };
    };
  };
}


