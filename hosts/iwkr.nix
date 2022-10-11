{ pkgs, lib, config, modulesPath, inputs, system, ... }: let
  asusPatchesRepo = pkgs.fetchFromGitLab {
    owner = "dragonn";
    repo = "linux-g14";
    rev = "7fe86b290b7b77ab55ea25033dafe47b5ac01b6f"; # tag 5.18 at 2022-08-12
    hash = "sha256-EZmnfxPyltuxoG+Xx3UvnZJiAH5weV6D9QF2XpyGCVI=";
  };
  asusPatches = map (name: { inherit name; patch = "${asusPatchesRepo}/${name}"; })
    [ "sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
      # "sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"
      # "sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
      "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
      "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
      # "sys-kernel_arch-sources-g14_files-0049-ALSA-hda-realtek-Add-quirk-for-ASUS-M16-GU603H.patch"
      # "sys-kernel_arch-sources-g14_files-8017-add_imc_networks_pid_0x3568.patch"
      "sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"
      "sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
      "sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"
      "sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
      "sys-kernel_arch-sources-g14_files-9012-Improve-usability-for-amd-pstate.patch"
      "0001-Fixes-98829e84dc67-asus-wmi-Add-dgpu-disable-method.patch"
      "0002-Fixes-382b91db8044-asus-wmi-Add-egpu-enable-method.patch"
      "0003-Fixes-ca91ea34778f-asus-wmi-Add-panel-overdrive-func.patch"
      "0004-asus-wmi-Refactor-disable_gpu-attribute.patch"
      "0005-asus-wmi-Refactor-egpu_enable-attribute.patch"
      "0006-asus-wmi-Refactor-panel_od-attribute.patch"
      "0007-asus-wmi-Convert-all-attr-show-to-use-sysfs_emit.patch"
      "0008-asus-wmi-Support-the-hardware-GPU-MUX-on-some-laptop.patch"
      "0009-asus-wmi-Adjust-tablet-lidflip-handling-to-use-enum.patch"
      "0010-asus-wmi-Add-support-for-ROG-X13-tablet-mode.patch"
      # "0011-asus-wmi-Modify-behaviour-of-Fn-F5-fan-key.patch"
      "0012-asus-wmi-Support-the-GPU-fan-on-TUF-laptops.patch"
      # "0013-sound-realtek-Add-pincfg-for-ASUS-G533Z.patch"
      # "0014-sound-realtek-Add-pincfg-for-ASUS-G513.patch"
      # "0015-HID-amd_sfh-Add-keyguard-for-ASUS-ROG-X13-tablet.patch"
      "0016-asus-wmi-Implement-TUF-laptop-keyboard-LED-modes.patch"
      "0017-asus-wmi-Implement-TUF-laptop-keyboard-power-states.patch" ];
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
  boot.kernelPackages = pkgs.linuxPackages_5_19; # inputs.nixpkgs-master.legacyPackages.${system}.linuxPackages_testing;
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
