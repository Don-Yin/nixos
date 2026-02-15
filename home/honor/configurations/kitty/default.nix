{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.82";
      window_padding_width = 12;
      confirm_os_window_close = 0;

      font_family = "Iosevka Nerd Font";
      font_size = 12;

      # Catppuccin Macchiato
      foreground = "#cad3f5";
      background = "#24273a";
      selection_foreground = "#24273a";
      selection_background = "#f4dbd6";

      cursor = "#f4dbd6";
      cursor_text_color = "#24273a";

      url_color = "#f4dbd6";

      active_border_color = "#b7bdf8";
      inactive_border_color = "#6e738d";

      # Black
      color0 = "#494d64";
      color8 = "#5b6078";
      # Red
      color1 = "#ed8796";
      color9 = "#ed8796";
      # Green
      color2 = "#a6da95";
      color10 = "#a6da95";
      # Yellow
      color3 = "#eed49f";
      color11 = "#eed49f";
      # Blue
      color4 = "#8aadf4";
      color12 = "#8aadf4";
      # Magenta
      color5 = "#f5bde6";
      color13 = "#f5bde6";
      # Cyan
      color6 = "#8bd5ca";
      color14 = "#8bd5ca";
      # White
      color7 = "#b8c0e0";
      color15 = "#a5adcb";
    };
  };
}
