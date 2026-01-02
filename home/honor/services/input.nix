{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      qt6Packages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons
    ];
  };

  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx5 input method";
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "/etc/profiles/per-user/honor/bin/fcitx5 -D -r --disable kimpanel";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  xdg.configFile = {
    "fcitx5/config".text = ''
      [Hotkey]
      TriggerKeys=Control+space
    '';
    "fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=pinyin

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=pinyin
      Layout=

      [GroupOrder]
      0=Default
    '';
  };
}

