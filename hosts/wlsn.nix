{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f59df329-504c-418b-a7d4-8c2f2cfa4175";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/25EC-ADD7";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ec9d9383-e096-40e2-a191-3845fe0039e2"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev"; # "nodev" for efi only
    theme = pkgs.nixos-grub2-theme;
  };
  boot.loader.efi.efiSysMountPoint = "/boot";

  # boot.kernelParams = [ "nomodeset" ];

  services.fwupd.enable = true;
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  services.xserver.dpi = 120;

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "shu";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  services.picom = {
    vSync = true;
    backend = "xrender";
    settings.unredir-if-possible = false;
  };

  time.timeZone = "America/Toronto";
  # Don't change this version.
  system.stateVersion = "21.11";

}