{ inputs, ... }:

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  services.xremap = {
    enable = true;
    withWlroots = true;
    deviceNames = [ "AT Translated Set 2 keyboard" ];
    config = {
      modmap = [
        {
          name = "Global Alt to Super (MacOS Command style)";
          remap = {
            "Alt_L" = "Super_L";
            "Alt_R" = "Super_R";
            "Super_L" = "Alt_L";
            "Super_R" = "Alt_R";
          };
        }
      ];
      keymap = [
        {
          name = "MacOS Basic Shortcuts (Global)";
          # exclude terminal apps where we want super to handle window management or different shortcuts
          application = { not = [ "kitty" "Kitty" "google-chrome" "Google-chrome" ]; };
          remap = {
            # Since Alt is now Super, we map Super+Key (which is physically Alt+Key) to Ctrl+Key
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            "Super-x" = "C-x";
            "Super-z" = "C-z";
            "Super-a" = "C-a";
            "Super-f" = "C-f";
            "Super-t" = "C-t";
            # "Super-w" = "C-w"; # Disabled globally to allow Hyprland to handle window closing
            "Super-r" = "C-r";
            "Super-s" = "C-s";
          };
        }
        {
          name = "Browser Shortcuts (Chrome)";
          application = { only = [ "google-chrome" "Google-chrome" ]; };
          remap = {
             "Super-c" = "C-c";
             "Super-v" = "C-v";
             "Super-x" = "C-x";
             "Super-z" = "C-z";
             "Super-a" = "C-a";
             "Super-f" = "C-f";
             "Super-t" = "C-t";
             "Super-w" = "C-w"; # Close tab
             "Super-r" = "C-r";
             "Super-s" = "C-s";
             "Super-Alt-Left" = "C-Shift-Tab";
             "Super-Alt-Right" = "C-Tab";
          };
        }
        {
          name = "Terminal Shortcuts (Kitty)";
          application = { only = [ "kitty" "Kitty" ]; };
          remap = {
            # Map Cmd+C/V to standard terminal copy/paste (Ctrl+Shift+C/V)
            "Super-c" = "C-Shift-c";
            "Super-v" = "C-Shift-v";
            # Leave Super-w alone so Hyprland catches it to close the window
            # "Super-w" = "C-Shift-w"; # Optional: if you want to close tab instead
          };
        }
      ];
    };
  };
  
  # create a systemd target for the Hyprland session; for xremap to work
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}

