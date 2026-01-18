{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd = {
    systemd.enable = true;
    luks.devices."iwkr-luks" = {
      device = "/dev/disk/by-uuid/a755f2f5-9198-4d9f-b3b7-554cf74b4578";
      allowDiscards = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3482cb46-5fcf-4a45-93fe-663fa70c8f9d";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CCCC-5F08";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/var/swap/swapfile";
      size = 16 * 1024;
    }
  ];
  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  powerManagement.enable = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev"; # "nodev" for efi only
    theme = pkgs.nixos-grub2-theme;
  };

  services.xserver.dpi = 96;

  services.supergfxd.enable = true;
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.fwupd.enable = true;


  services.fprintd.enable = true;

  time.timeZone = "America/Toronto";
  # Don't change this version.
  system.stateVersion = "21.11";

}
