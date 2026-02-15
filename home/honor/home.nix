{ config, pkgs, ... }:

{
  home.username = "honor";
  home.homeDirectory = "/home/honor";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    brightnessctl
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./services/xremap.nix
    ./services/input.nix
    ./services/session.nix
    ./configurations/kitty/default.nix
  ];

  programs.bash = {
    enable = true;
    profileExtra = builtins.readFile ./dotfiles/bash_profile.sh;
    initExtra = builtins.readFile ./dotfiles/bashrc.sh;
  };

  # Manage dotfiles via Home Manager
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./configurations/hyprland/hyprland.conf;
    "hypr/hyprland.base.conf".source = ./configurations/hyprland/hyprland.base.conf;
    "hypr/hyprland.custom.conf".source = ./configurations/hyprland/hyprland.custom.conf;
    "hypr/wallpaper.sh" = { source = ./configurations/hyprland/wallpaper.sh; executable = true; };
    "waybar/config".source = ./configurations/waybar/config;
    "waybar/style.css".source = ./configurations/waybar/style.css;
    "wofi/config".source = ./configurations/wofi/config;
    "wofi/style.css".source = ./configurations/wofi/style.css;
  };
}

