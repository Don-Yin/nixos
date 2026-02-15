{ config, lib, pkgs, ... }:

{
  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.hyprland = { enable = true; xwayland.enable = true; };
  security.rtkit.enable = true;   # real-time priority for PipeWire (glitch-free audio)
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = [
    # CLI / core
    pkgs.git
    pkgs.git-lfs
    pkgs.htop
    pkgs.tmux

    # Dev
    pkgs.nodejs_24

    # Desktop apps
    pkgs.google-chrome
    pkgs.localsend
    pkgs.kitty
    pkgs.wofi
    pkgs.waybar
    pkgs.dunst
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.helvum
    pkgs.seahorse

    # Wallpaper & media
    pkgs.swww
    pkgs.playerctl
    pkgs.libnotify

    # Theming / runtime glue
    pkgs.adwaita-icon-theme
    pkgs.glib
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
