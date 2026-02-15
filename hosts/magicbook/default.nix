{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/users.nix
    ../../modules/system/network.nix
    ../../modules/system/timezone.nix
    ../../modules/desktop/apps.nix
    ../../modules/desktop/font.nix
    ../../modules/services/openssh.nix
    ../../modules/services/vpn.nix
    ../../modules/services/eduroam-autoconnect.nix
  ];

  networking.hostName = "magicbook";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Services (set enable = true in the host that needs them)
  services.china-vpn.enable = false;
  services.eduroam-autoconnect = {
    enable = false;
    identity = "dy323+honor@cam.ac.uk";
    passwordFile = "/home/honor/nix-configurations/secrets/eduroam.password";
  };

  # uinput for xremap
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "honor" ];
  users.groups.input.members = [ "honor" ];

  system.stateVersion = "25.11";
}
