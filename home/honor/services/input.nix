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
      fcitx5-rime
      rime-ice
      qt6Packages.fcitx5-chinese-addons # keep as fallback
    ];
  };

  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx5 input method";
    };

    Service = {
      ExecStart = "/etc/profiles/per-user/honor/bin/fcitx5 -D -r --disable kimpanel";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
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
      DefaultIM=rime

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=rime
      Layout=

      [GroupOrder]
      0=Default
    '';
    "fcitx5/rime/default.custom.yaml".text = ''
      patch:
        "menu/page_size": 9
        schema_list:
          - schema: rime_ice
    '';
    "fcitx5/rime/rime_ice.custom.yaml".text = ''
      patch:
        "switches/@0/reset": 1
    '';
  };
}

