{ config, pkgs, ... }:

{
  # Enable touchpad and touchscreen support (enabled default in most desktopManager).

  environment.systemPackages = with pkgs; [ libwacom ];
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      tappingDragLock = false;
      disableWhileTyping = true;
      horizontalScrolling = false;
      accelSpeed = "0.4";
      accelProfile = "adaptive";
    };
  };

  services.xserver.wacom.enable = true;
  # services.xserver.digimend.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # Touchégg is a multitouch gesture recognizer.
  services.touchegg.enable = true;
}
