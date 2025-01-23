{ lib, pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    waypipe
    krfb
    plasma5Packages.kdeconnect-kde
    squeekboard
  ];
}
