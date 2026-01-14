{ config, lib, pkgs, ... }:

{
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  # LocalSend default discovery/transfer port.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
}

