# Acknowledgement: oxalica
# https://github.com/oxalica/nixos-config/blob/master/nixos/iso/configuration.nix

{ lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-plasma5.nix")
    ./localisation.nix
  ];

  isoImage = {
    isoBaseName = "livecd";
    volumeID = "LIVECD";
    # Worse compression but way faster.
    squashfsCompression = "zstd -Xcompression-level 6";
  };

  environment.systemPackages = with pkgs; [
    neofetch emacs firefox clash p7zip busybox
  ];
  
  system.stateVersion = "21.11";
}