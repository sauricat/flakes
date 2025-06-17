{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; with kdePackages; [
    krfb
    kdeconnect-kde
    waypipe
    squeekboard
  ];
}
