{ pkgs, lib, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_testing;
  # Since there are rc kernel packages, we need to disable zfs support.
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  boot.kernelPatches = let
    repo = pkgs.fetchFromGitLab {
      owner = "dragonn";
      repo = "linux-g14";
      rev = "5.18";
      hash = "sha256-tZ0vK4djzDWl931O3vFvRt8ztlMoHr2Hvg8vE5hIBEs=";
    };
  in
    map (name: { inherit name; patch = "${repo}/${name}"; })
      [ "sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
        # "sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"
        "sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
        "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
        "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
        "sys-kernel_arch-sources-g14_files-0049-ALSA-hda-realtek-Add-quirk-for-ASUS-M16-GU603H.patch"
        "sys-kernel_arch-sources-g14_files-0050-asus-flow-x13-support_sw_tablet_mode.patch"
        "sys-kernel_arch-sources-g14_files-8017-add_imc_networks_pid_0x3568.patch"
        "sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"
        "sys-kernel_arch-sources-g14_files-9001-v5.16.11-s0ix-patch-2022-02-23.patch"
        "sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
        "sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"
        "sys-kernel_arch-sources-g14_files-9006-amd-c3-entry.patch"
        "sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
        "sys-kernel_arch-sources-g14_files-9012-Improve-usability-for-amd-pstate.patch" ];

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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
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
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  systemd.sleep.extraConfig = "SuspendState=mem";

  # Don't change this version.
  system.stateVersion = "21.11";

}
