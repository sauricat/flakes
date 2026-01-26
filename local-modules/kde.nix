{ pkgs, ... }:
{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = [ pkgs.kdePackages.okular ];
  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      krfb
      kdeconnect-kde
      waypipe
      plasma-keyboard
    ];
}
