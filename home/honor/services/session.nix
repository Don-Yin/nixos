{ pkgs, ... }:

{
  # Start common session programs via systemd --user instead of Hyprland exec-once.

  # Startable target for Hyprland sessions (unlike graphical-session.target which refuses manual start).
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special(7)" ];
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  # Ensure KDE Connect daemon starts in the session (service is provided by kdeconnect).
  systemd.user.services.kdeconnect-autostart = {
    Unit = {
      Description = "KDE Connect autostart";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user start app-org.kde.kdeconnect.daemon@autostart.service";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}


