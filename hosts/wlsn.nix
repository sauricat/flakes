{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" "hid-apple" ];
  boot.extraModprobeConfig = ''
      options hid_apple fnmode=2
  ''; # fix keyboard fn keys dysfunction

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1b241f02-b9b5-4667-8d7a-9dc1b12b18b3";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5A55-F4D7";
      fsType = "vfat";
    };

  swapDevices = [ ];

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
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev"; # "nodev" for efi only
    theme = pkgs.nixos-grub2-theme;

    extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root $FS_UUID
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }

        menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
          fwsetup
	      }
      '';
  };

  #! Secure Boot !!
  boot.bootspec.enable = true;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

  boot.loader.efi.efiSysMountPoint = "/boot";

  services.fwupd.enable = true;
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  services.xserver.dpi = 96;

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Former 1070 Graphics Card Config
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.enable = true;
  # services.picom = {
  #   vSync = true;
  #   backend = "xrender";
  #   settings.unredir-if-possible = false;
  # };

  time.timeZone = "America/Toronto";
  # Don't change this version.
  system.stateVersion = "21.11";

}
