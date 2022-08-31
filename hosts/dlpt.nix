{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # hardware-configuration.nix
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/915ab4c6-fd53-4d09-b00a-ba4049aba3a9";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6A20-9B7E";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/8e7351b7-dee3-4993-b63b-f87fcf83536f"; }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # configuration.nix
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

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
  boot.kernelModules = [ "kvm-intel" "v4l2loopback" "snd-aloop" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    options hid_apple fnmode=2
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

  powerManagement.resumeCommands = "${pkgs.msr-tools}/bin/wrmsr -a 0x19a 0x0";

  environment.systemPackages = [ pkgs.throttled ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v28n.psf.gz";

  services.xserver.dpi = 140;

  time.timeZone = "Asia/Shanghai";

  # Don't change this version.
  system.stateVersion = "21.11";
}

