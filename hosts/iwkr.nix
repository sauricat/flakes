{ pkgs, lib, config, modulesPath, inputs, system, ... }: let
  asusPatchesRepo = pkgs.fetchFromGitLab {
    owner = "dragonn";
    repo = "linux-g14";
    rev = "067032b3b35a80f580cc4132d7d53986c7a24184"; # tag 5.19- at 2022-10-10
    hash = "sha256-CVKiFlgNtkz497rTKBARUuqT6fgpJ56IQM5Og6pW2qQ=";
  };
  asusPatches = map (name: { inherit name; patch = "${asusPatchesRepo}/${name}"; })
    [
      "0001-acpi-proc-idle-skip-dummy-wait.patch"
      # "0001-asus-wmi-Expand-support-of-GPU-fan-to-read-RPM-and-l.patch"
      "0001-asus-wmi-tuf-gpu-fan.patch"
      # "0001-HID-amd_sfh-Add-keyguard-for-ASUS-ROG-X13-tablet.patch"
      "0001-platform-x86-asus-wmi-Convert-all-attr-show-to-use-s.patch"
      # "0001-s2idle-use-microsoft-guid.patch"
      "0002-platform-x86-asus-wmi-Use-kobj_to_dev.patch"
      # "0002-s2idle-use-microsoft-guid.patch"
      "0003-platform-x86-asus-wmi-Document-the-dgpu_disable-sysf.patch"
      # "0003-s2idle-use-microsoft-guid.patch"
      "0004-platform-x86-asus-wmi-Document-the-egpu_enable-sysfs.patch"
      # "0004-s2idle-use-microsoft-guid.patch"
      "0005-platform-x86-asus-wmi-Document-the-panel_od-sysfs-at.patch"
      # "0005-s2idle-use-microsoft-guid.patch"
      "0006-platform-x86-asus-wmi-Refactor-disable_gpu-attribute.patch"
      # "0006-s2idle-use-microsoft-guid.patch"
      "0007-platform-x86-asus-wmi-Refactor-egpu_enable-attribute.patch"
      # "0007-s2idle-use-microsoft-guid.patch"
      "0008-platform-x86-asus-wmi-Refactor-panel_od-attribute.patch"
      # "0008-s2idle-use-microsoft-guid.patch"
      "0009-platform-x86-asus-wmi-Simplify-some-of-the-_check_pr.patch"
      "0010-platform-x86-asus-wmi-Support-the-hardware-GPU-MUX-o.patch"
      "0011-platform-x86-asus-wmi-Adjust-tablet-lidflip-handling.patch"
      "0012-platform-x86-asus-wmi-Add-support-for-ROG-X13-tablet.patch"
      "0013-platform-x86-asus-wmi-Simplify-tablet-mode-switch-pr.patch"
      "0014-platform-x86-asus-wmi-Simplify-tablet-mode-switch-ha.patch"
      "0017-asus-wmi-Implement-TUF-laptop-keyboard-LED-modes.patch"
      "0018-asus-wmi-Implement-TUF-laptop-keyboard-power-states.patch"
      "0019-HID-amd_sfh-Add-keyguard-for-ASUS-ROG-X13-tablet.patch"
      "0020-asus-wmi-Modify-behaviour-of-Fn-F5-fan-key.patch"
      "0021-rog-x16-patch-test1.patch"
      "0022-gv601r-tablet-mode-test.patch"
      "0023-mediatek-bt-add-e0e2.patch"
      "0024-pahole-124-fix.patch"
      "sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
      # "sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"
      "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
      "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
      "sys-kernel_arch-sources-g14_files-0049-ALSA-hda-realtek-Add-quirk-for-ASUS-M16-GU603H.patch"
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
  # boot.initrd.kernelModules = [ "amd_pstate" ]; # already in boot.kernelPatches
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = inputs.nixpkgs-master.legacyPackages.${system}.linuxPackages_testing;
  # Since there are rc kernel packages, we need to disable zfs support.
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  boot.kernelPatches = lib.singleton {
    name = "amd-pstate";
    patch = null;
    extraConfig = "X86_AMD_PSTATE y";
  } ++ asusPatches;

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

  services.xserver.dpi = 140;

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
