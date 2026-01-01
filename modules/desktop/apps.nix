{ config, lib, pkgs, ... }:

{
  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; # for nix-ld to work with cursor remote
  programs.hyprland = { enable = true; xwayland.enable = true; };
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;  # key management for gnome
  security.pam.services.login.enableGnomeKeyring = true;  # enable keyring for login

  environment.systemPackages = with pkgs; [
    git
    nodejs_24
    google-chrome
    localsend
    kitty
    hyprpaper
    wofi
    waybar
    dunst
    networkmanagerapplet
    tmux
    adwaita-icon-theme
    glib # for gsettings
    pavucontrol
    helvum
    seahorse # gui for gnome-keyring
  ];

  # clash-verge; uncomment when not on proxy
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
  };

  environment.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.google-chrome}/bin/google-chrome-stable";
    BROWSER = "google-chrome-stable";

    # proxy settings - adjust port if you changed it in Clash Verge
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
    all_proxy = "socks5://127.0.0.1:7897";

    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    GTK_THEME = "Adwaita";
  };

}
