{ inputs, ... }:

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
      modmap = [
        {
          name = "Swap Alt and Super";
          remap = {
            "Alt_L" = "Super_L";
            "Alt_R" = "Super_R";
            "Super_L" = "Alt_L";
            "Super_R" = "Alt_R";
          };
        }
      ];

      # Bring back "macOS-like" shortcuts for Chrome only:
      # Super+C/V/... -> Ctrl+C/V/... (copy/paste/etc).
      keymap = [
        {
          name = "Chrome: Super-as-Ctrl shortcuts";
          application = { only = [ "google-chrome" "Google-chrome" "google-chrome-stable" "Google-chrome-stable" ]; };
          remap = {
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            "Super-x" = "C-x";
            "Super-z" = "C-z";
            "Super-a" = "C-a";
            "Super-f" = "C-f";
            "Super-t" = "C-t";
            "Super-w" = "C-w"; # close tab
            "Super-r" = "C-r";
            "Super-s" = "C-s";
            "Super-Alt-Left" = "C-Shift-Tab"; # previous tab
            "Super-Alt-Right" = "C-Tab"; # next tab
          };
        }
        {
          name = "Cursor: Super-as-Ctrl shortcuts";
          application = { only = [ "cursor" "Cursor" ]; };
          remap = {
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            # Cursor/VSCode integrated terminal uses Ctrl+Shift+C/V for copy/paste.
            "Super-Shift-c" = "C-Shift-c";
            "Super-Shift-v" = "C-Shift-v";
            "Super-x" = "C-x";
            "Super-z" = "C-z";
            "Super-a" = "C-a";
            "Super-f" = "C-f";
            "Super-t" = "C-t";
            "Super-w" = "C-w";
            "Super-r" = "C-r";
            "Super-s" = "C-s";
          };
        }
      ];
    };
  };
}

