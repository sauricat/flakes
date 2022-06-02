# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../software.nix
      ../user.nix
      ../services/localisation.nix
      ../services/bluetooth.nix
      ../services/multitouch.nix
      ../services/network.nix
      ../services/virtualisation.nix
      ../services/nix.nix
      ../other-package-managers/guix-daemon.nix
      ../other-package-managers/pacman.nix
    ];

  networking.hostName = "dlpt";
  networking.interfaces.wlp0s20f3.useDHCP = false;

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev"; # "nodev" for efi only
    theme = pkgs.nixos-grub2-theme;
  };
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Perform firmware updates.
  services.fwupd.enable = true; 

  # Add NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Power management.
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  # Fix cannot sleep issue.
  systemd.sleep.extraConfig = "SuspendState=freeze";

  environment.systemPackages = [ pkgs.throttled ];
  
  # Don't change this version.
  system.stateVersion = "21.11"; 

}

