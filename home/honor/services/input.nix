{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      # Config UI (useful for debugging + setting hotkeys)
      qt6Packages.fcitx5-configtool
      fcitx5-gtk

      # Qt input method modules (required for many Qt apps)
      libsForQt5.fcitx5-qt
      qt6Packages.fcitx5-qt

      qt6Packages.fcitx5-chinese-addons
    ];
  };

  # Start fcitx5 reliably in the user session (so `fcitx5-remote` can see it).
  # This is more reliable than `exec-once` in the compositor.
  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx5 input method";
      PartOf = [ "hyprland-session.target" "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      # Run in foreground so systemd can track it (do NOT use -d).
      # IMPORTANT: use the user-profile wrapped fcitx5 so it can see configured addons (Pinyin, etc.).
      ExecStart = "/etc/profiles/per-user/honor/bin/fcitx5 -D -r";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  xdg.configFile = {
    "fcitx5/config".text = ''
      [Hotkey]
      # Trigger Input Method
      # Keep fcitx5 default-ish hotkeys simple; Hyprland is responsible for our custom toggles.
      TriggerKeys=Control+space
    '';
    "fcitx5/profile".text = ''
      [Groups/0]
      # Group Name
      Name=Default
      # Layout
      Default Layout=us
      # Default Input Method
      DefaultIM=pinyin

      [Groups/0/Items/0]
      # Name
      Name=keyboard-us
      # Layout
      Layout=

      [Groups/0/Items/1]
      # Name
      Name=pinyin
      # Layout
      Layout=

      [GroupOrder]
      0=Default
    '';
  };
}

