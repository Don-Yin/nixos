{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Style & Transparency
      background_opacity = "0.8";
      window_padding_width = 10;
      
      # Fonts
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      # Hyprland Blue Theme
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#33ccff"; # Hyprland Blue

      # Cursor
      cursor = "#33ccff";
      cursor_text_color = "#1e1e2e";

      # URL
      url_color = "#33ccff";

      # Border
      active_border_color = "#33ccff";
      inactive_border_color = "#585b70";

      # Color Palette (Blue-focused)
      # Black
      color0 = "#45475a";
      color8 = "#585b70";
      # Red
      color1 = "#f38ba8";
      color9 = "#f38ba8";
      # Green
      color2 = "#a6e3a1";
      color10 = "#a6e3a1";
      # Yellow
      color3 = "#f9e2af";
      color11 = "#f9e2af";
      # Blue (Hyprland Blue)
      color4 = "#33ccff";
      color12 = "#33ccff";
      # Magenta
      color5 = "#f5c2e7";
      color13 = "#f5c2e7";
      # Cyan
      color6 = "#94e2d5";
      color14 = "#94e2d5";
      # White
      color7 = "#bac2de";
      color15 = "#a6adc8";
    };
  };
}

