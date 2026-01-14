{ inputs, ... }:

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  services.xremap = {
    enable = true; # Chrome-only shortcuts (no global Alt/Super swapping)
    withWlroots = true;
    deviceNames = [ "AT Translated Set 2 keyboard" ];
    config = {
      # No modmap: keep physical keys as-is (no Alt <-> Super swapping)
      modmap = [];

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
      ];
    };
  };
}

