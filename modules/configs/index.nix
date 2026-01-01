{ config, pkgs, ... }:

{
  # waybar configuration
  environment.etc."xdg/waybar/config".source = ./files/waybar/config;
  environment.etc."xdg/waybar/style.css".source = ./files/waybar/style.css;

  # hyprland configuration
  environment.etc."xdg/hypr/hyprland.conf".source = ./files/hyprland/hyprland.conf;

  # wofi configuration
  environment.etc."xdg/wofi/config".source = ./files/wofi/config;
  environment.etc."xdg/wofi/style.css".source = ./files/wofi/style.css;
}
