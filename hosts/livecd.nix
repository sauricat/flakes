{ lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-plasma5.nix")
  ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_18;
  isoImage = {
    isoBaseName = "livecd";
    volumeID = "LIVECD";
    # Worse compression but way faster.
    squashfsCompression = "zstd -Xcompression-level 6";
  };

  environment.systemPackages = with pkgs; [
    neofetch firefox
  ];

  system.stateVersion = "21.11";
}
