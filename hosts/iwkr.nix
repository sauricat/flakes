{ pkgs, lib, config, modulesPath, inputs, system, ... }: # let
  # asusPatchesRepo = pkgs.fetchFromGitLab {
  #   owner = "dragonn";
  #   repo = "linux-g14";
  #   rev = "6.6";
  #   hash = "sha256-JHxkNYvD8dtw6kqHGVUEZBUdhYXAywfUoYWsGEChT6Q=";
  # };
  # asusPatches = map (name: { inherit name; patch = "${asusPatchesRepo}/${name}"; })
  #   [
  #     "0001-acpi-proc-idle-skip-dummy-wait.patch"
  #     "0001-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"
  #     "0001-ALSA-hda-realtek-Add-quirk-for-ASUS-ROG-G814Jx.patch"
  #     "0001-linux6.6.y-bore3.3.0.patch"
  #     "0001-platform-x86-asus-wmi-Add-safety-checks-to-dgpu-egpu.patch"
  #     "0001-platform-x86-asus-wmi-Support-2023-ROG-X16-tablet-mo.patch"
  #     "0002-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"
  #     "0005-platform-x86-asus-wmi-don-t-allow-eGPU-switching-if-.patch"
  #     "0006-platform-x86-asus-wmi-add-safety-checks-to-gpu-switc.patch"
  #     "0032-Bluetooth-btusb-Add-a-new-PID-VID-0489-e0f6-for-MT7922.patch"
  #     "0035-Add_quirk_for_polling_the_KBD_port.patch"
  #     "0038-mediatek-pci-reset.patch"
  #     "0040-workaround_hardware_decoding_amdgpu.patch"
  #     "amd-tablet-sfh.patch"
  #     "sys-kernel_arch-sources-g14_files-0004-5.17+--more-uarches-for-kernel.patch"
  #     "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
  #     "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
  #     "v2-0002-ALSA-hda-cs35l41-Support-ASUS-2023-laptops-with-m.patch"
  #     "v2-0005-platform-x86-asus-wmi-don-t-allow-eGPU-switching-.patch"
  #     "v2-0006-platform-x86-asus-wmi-add-safety-checks-to-gpu-sw.patch"
  #     "v6-0001-platform-x86-asus-wmi-add-support-for-ASUS-screen.patch"
  #   ];
# in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     linux-firmware = prev.linux-firmware.overrideAttrs (old: {
  #       version = "20220725";
  #       src = final.fetchzip {
  #         url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-150864a4d73e8c448eb1e2c68e65f07635fe1a66.tar.gz";
  #         sha256 = "sha256-fZuEKbVwFsmfsz3n36CPptasOXJ+TO0L6gQL0INJgiE=";
  #       };
  #       outputHash = "sha256-uWPfRzXZ+VPD2V0TH8nXr+1gtYumgDI/Dy3RUdnUoRU=";
  #     });
  #   })
  # ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  # boot.kernelPackages = pkgs.linuxPackages_6_6; # inputs.nixpkgs-master.legacyPackages.${system}.linuxPackages_testing;
  # Since there are not rc kernel packages, we need not to disable zfs support.
  # boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  # boot.kernelPatches = asusPatches;

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
    # extraFiles."acpi_override" = ./iwkr/acpi_override;
  };

  services.xserver.dpi = 96;

  services.asusd.enable = true;
  services.fwupd.enable = true;
  # boot.initrd.prepend = [ "${./iwkr/acpi_override}" ];

  boot.kernelParams = [
    # "mem_sleep_default=deep" # acpi override company
    "amd_iommu=off" "idle=nomwait" "amdgpu.gpu_recovery=1" # https://wiki.archlinux.org/title/Laptop/ASUS#Black_screen_after_sleep
  ];

  time.timeZone = "America/Toronto";
  # Don't change this version.
  system.stateVersion = "21.11";

}
