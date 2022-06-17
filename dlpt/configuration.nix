# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../basics.nix
      ../user.nix
      ../services/localisation.nix
      ../services/bluetooth.nix
      ../services/multitouch.nix
      ../services/network.nix
      ../services/virtualisation.nix
      ../services/nix.nix
      ../other-package-managers/guix-daemon.nix
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

  # Virtual Cam & Mic support
  # https://www.reddit.com/r/NixOS/comments/p8bqvu/how_to_install_v4l2looback_kernel_module/
  boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  
  # Perform firmware updates.
  services.fwupd.enable = true;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Add NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Power management.
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  # Fix cannot sleep issue.
  systemd.sleep.extraConfig = "SuspendState=freeze";

  environment.systemPackages = [ pkgs.throttled ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v28n.psf.gz";
  
  # Don't change this version.
  system.stateVersion = "21.11"; 
}

