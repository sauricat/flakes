# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../software.nix
      ../services/network.nix
      ../services/localisation.nix
      ../services/nix.nix
      ../user.nix
    ];

  networking.hostName = "dvm"; # Define your hostname.

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  # Vmware support
  virtualisation.vmware.guest.enable = true;
  environment.systemPackages = [ pkgs.open-vm-tools ];
  
  # Don't change this version.
  system.stateVersion = "21.11"; 

}

