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

  # Swap file for hibernate (needs to be >= RAM for full hibernate)
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024;   # 32 GB in MB
  }];

  # Lid close → suspend-then-hibernate (saves battery on s2idle laptops)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "30min";
  };

  # After 30min of s2idle suspend, hibernate to disk to save battery
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  # Try deep sleep if firmware supports it
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # uinput for xremap
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "honor" ];

  system.stateVersion = "25.11";
}
