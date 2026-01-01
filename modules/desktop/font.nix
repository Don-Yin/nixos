{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only
  ];

  fonts.fontDir.enable = true;
}

