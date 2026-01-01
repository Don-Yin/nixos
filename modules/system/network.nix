{ config, lib, pkgs, ... }:

{
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "114.114.114.114" "223.5.5.5" ];
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];
}

