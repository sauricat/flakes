{ inputs, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-plasma5.nix")
    inputs.home-manager.nixosModules.home-manager
  ];
  boot.kernelPackages = pkgs.linuxPackages_testing;
  # Since there are rc kernel packages, we need to disable zfs support.
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  isoImage = {
    isoBaseName = "livecd";
    volumeID = "LIVECD";
    # Worse compression but way faster.
    squashfsCompression = "zstd -Xcompression-level 6";
  };

  environment.systemPackages = with pkgs; [
    neofetch
    firefox
    emacs # a basic version of emacs
  ];

  home-manager.users.nixos = {
    home.file.clash-configuration.source = ../clash-configuration-temp; # the source does not exist until the flake
                                                                        # compilation is called by `build.sh', see
                                                                        # lines 69-71 of it.
    home.file.configuration.source = ../.;
    home.stateVersion = "21.11";
  };

  system.stateVersion = "21.11";
}
