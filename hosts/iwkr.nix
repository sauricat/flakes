{ pkgs, lib, config, modulesPath, inputs, system, ... }: let
  asusPatchesRepo = pkgs.fetchFromGitLab {
    owner = "dragonn";
    repo = "linux-g14";
    rev = "de92b78ab64dfee61a69fc3c31f339c988ce1729"; # "5.15";
    hash = "sha256-XPVmA/nDumBj+UUMKeHcLQB0if1dhE0xpOscmbDdTbs=";
  };
  asusPatches = map (name: { inherit name; patch = "${asusPatchesRepo}/${name}"; })
    [
      "sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
      "sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"
      "sys-kernel_arch-sources-g14_files-0006-zstd.patch"
      # "sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
      "sys-kernel_arch-sources-g14_files-0046-fan-curvers.patch"
      # "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
      # "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-Allow-configuring-SW_TABLET.patch"
      "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
      "sys-kernel_arch-sources-g14_files-8012-mt76-mt7915-send-EAPOL-frames-at-lowest-rate.patch"
      "sys-kernel_arch-sources-g14_files-8013-mt76-mt7921-robustify-hardware-initialization-flow.patch"
      # "sys-kernel_arch-sources-g14_files-8014-mt76-mt7921-fix-retrying-release-semaphore-without-end.patch"
      "sys-kernel_arch-sources-g14_files-8015-mt76-mt7921-send-EAPOL-frames-at-lowest-rate.patch"
      "sys-kernel_arch-sources-g14_files-8016-mt76-mt7921-Add-mt7922-support.patch"
      "sys-kernel_arch-sources-g14_files-8017-mt76-mt7921-enable-VO-tx-aggregation.patch"
      # "sys-kernel_arch-sources-g14_files-8024-mediatek-more-bt-patches.patch"
      "sys-kernel_arch-sources-g14_files-8026-cfg80211-dont-WARN-if-a-self-managed-device.patch"
      "sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"
      # "sys-kernel_arch-sources-g14_files-9001-v5.15.8-s0ix-patch-2021-12-14.patch"
      "sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
      "sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"
      "sys-kernel_arch-sources-g14_files-9006-amd-c3-entry.patch"
      # "sys-kernel_arch-sources-g14_files-9007-squashed-net-tcp_bbr-bbr2-for-5.14.y.patch"
      "sys-kernel_arch-sources-g14_files-9008-fix-cpu-hotplug.patch"
      # "sys-kernel_arch-sources-g14_files-9009-amd-pstate-sqashed-v7.patch"
      "sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
      "sys-kernel_arch-sources-g14_files-9012-x86-change-default-to-spec_store_bypass_disable-prct.patch"
      "sys-kernel_arch-sources-g14_files-9052-x86-csum-Rewrite-optimize-csum_partial.patch"
    ];
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware = prev.linux-firmware.overrideAttrs (old: {
        version = "20220725";
        src = final.fetchzip {
          url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-150864a4d73e8c448eb1e2c68e65f07635fe1a66.tar.gz";
          sha256 = "sha256-fZuEKbVwFsmfsz3n36CPptasOXJ+TO0L6gQL0INJgiE=";
        };
        outputHash = "sha256-uWPfRzXZ+VPD2V0TH8nXr+1gtYumgDI/Dy3RUdnUoRU=";
      });
    })
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ "amd_pstate" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_5_15; # inputs.nixpkgs-master.legacyPackages.${system}.linuxPackages_testing;
  # Since there are rc kernel packages, we need to disable zfs support.
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  boot.kernelPatches = asusPatches;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2e8935cb-c1e6-4c77-b183-96d46b7978d0";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/785A-D7D5";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5df5da95-bac5-498d-bff9-94b2014fbf57"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev"; # "nodev" for efi only
    theme = pkgs.nixos-grub2-theme;
    extraFiles."acpi_override" = ./iwkr/acpi_override;
  };
  boot.loader.efi.efiSysMountPoint = "/boot";

  services.xserver.dpi = 96;

  services.asusd.enable = true;
  services.fwupd.enable = true;
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  boot.initrd.prepend = [ "${./iwkr/acpi_override}" ];

  boot.kernelParams = [
    # "mem_sleep_default=deep" # acpi override company
    "amd_iommu=off" "idle=nomwait" "amdgpu.gpu_recovery=1" # https://wiki.archlinux.org/title/Laptop/ASUS#Black_screen_after_sleep
  ];

  time.timeZone = "America/Toronto";
  # Don't change this version.
  system.stateVersion = "21.11";

}
