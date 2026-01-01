{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    wqy_zenhei
    wqy_microhei
  ];

  fonts.fontDir.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
      serif = [ "Noto Serif" "Noto Serif CJK SC" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
    };
  };
}

