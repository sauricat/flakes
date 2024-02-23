{ lib, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;
  services.xserver.desktopManager.gnome.enable = true;
}

