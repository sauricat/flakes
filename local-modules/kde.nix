{ lib, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    plasma5Packages.bismuth
    squeekboard
  ];
}
