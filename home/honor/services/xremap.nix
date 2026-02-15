{ inputs, lib, ... }:

let
  # ------------------------------------------------------------------------------------
  # Keyboard design (single source of truth):
  #
  # - Goal: "macOS-like" muscle memory on a PC keyboard
  #   - physical Alt acts like "Command" (Super)
  #   - physical Super acts like "Alt"
  #
  # - Then, in *specific apps*, map Super+Key -> Ctrl+Key for common shortcuts:
  #   - Chrome: copy/paste/tab close + tab switching
  #   - Other apps: can add more blocks below following the Chrome pattern
  #
  # Notes:
  # - Hyprland uses $mainMod = SUPER so physical Alt becomes your WM modifier (via the swap).
  # - This file intentionally avoids global "mac shortcuts everywhere" to reduce surprises.
  # ------------------------------------------------------------------------------------
  #
  # Set to false if you ever want to return to normal PC layout without editing the remaps.
  swapAltSuper = true;

  chromeApps = [ "google-chrome" "Google-chrome" "google-chrome-stable" "Google-chrome-stable" ];

  superAsCtrlCommon = {
    "Super-c" = "C-c";
    "Super-v" = "C-v";
    "Super-x" = "C-x";
    "Super-z" = "C-z";
    "Super-a" = "C-a";
    "Super-f" = "C-f";
    "Super-t" = "C-t";
    "Super-w" = "C-w";
    "Super-r" = "C-r";
    "Super-s" = "C-s";
  };

  chromeExtra = {
    # Tab switching
    "Super-Alt-Left" = "C-Shift-Tab";
    "Super-Alt-Right" = "C-Tab";
  };

in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  services.xremap = {
    enable = true; # Chrome shortcuts + restore physical Alt behaving like Super (swap Alt<->Super)
    withWlroots = true;
    deviceNames = [ "AT Translated Set 2 keyboard" ];
    config = {
      # Swap Alt and Super so the physical Alt key acts like "Command/Super".
      # (Matches your old setup: physical Alt -> Super, physical Super -> Alt.)
      modmap =
        if swapAltSuper then
          [
            {
              name = "Swap Alt and Super";
              remap = {
                "Alt_L" = "Super_L";
                "Alt_R" = "Super_R";
                "Super_L" = "Alt_L";
                "Super_R" = "Alt_R";
              };
            }
          ]
        else
          [];

      # Bring back "macOS-like" shortcuts for Chrome only:
      # Super+C/V/... -> Ctrl+C/V/... (copy/paste/etc).
      keymap = [
        {
          name = "Chrome: Super-as-Ctrl shortcuts";
          application = { only = chromeApps; };
          remap = superAsCtrlCommon // chromeExtra;
        }
      ];
    };
  };

  # xremap's module ships a service WantedBy=graphical-session.target, which isn't startable
  # in a Hyprland session started outside a display manager. Re-wire it to our session target.
  systemd.user.services.xremap = {
    Unit.PartOf = lib.mkForce [ "hyprland-session.target" ];
    Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
  };
}

