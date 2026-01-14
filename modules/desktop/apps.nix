{ config, lib, pkgs, ... }:

let
  # KDE Connect binaries can be unwrapped Qt ELFs; wrapping ensures Qt plugin + runtime deps are found at runtime.
  # NOTE: Do not reference pkgs.kdeconnect-kde here: the top-level alias was removed when KDE Gear 5 (Qt5) EOL'd.
  # Use the Qt 6-based package explicitly.
  kdeconnectPkg = pkgs.kdePackages.kdeconnect-kde;

  kdeconnectWrapped = pkgs.symlinkJoin {
    name = "kdeconnect-kde-wrapped";
    paths = [ kdeconnectPkg ];
    nativeBuildInputs = [ pkgs.qt6.wrapQtAppsHook ];
    buildInputs = [
      pkgs.qt6.qtbase
      pkgs.qt6.qtwayland
    ];
  };
in
{
  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; # for nix-ld to work with cursor remote
  programs.kdeconnect.enable = true;
  programs.hyprland = { enable = true; xwayland.enable = true; };
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;  # key management for gnome
  security.pam.services.login.enableGnomeKeyring = true;  # enable keyring for login

  environment.systemPackages = [
    # CLI / core
    pkgs.git
    pkgs.htop
    pkgs.tmux

    # Dev
    pkgs.nodejs_24
    pkgs.code-cursor

    # Desktop apps
    pkgs.google-chrome
    pkgs.localsend
    pkgs.kitty
    pkgs.wofi
    pkgs.waybar
    pkgs.dunst
    pkgs.networkmanagerapplet
    kdeconnectWrapped
    pkgs.pavucontrol
    pkgs.helvum
    pkgs.seahorse # gui for gnome-keyring

    # Theming / runtime glue
    pkgs.adwaita-icon-theme
    pkgs.glib # for gsettings
    pkgs.xcb-util-cursor # Qt xcb platform plugin needs libxcb-cursor.so.0
  ];

  environment.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.google-chrome}/bin/google-chrome-stable";
    BROWSER = "google-chrome-stable";

    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    GTK_THEME = "Adwaita";
    NIXOS_OZONE_WL = "1";
  };

}
