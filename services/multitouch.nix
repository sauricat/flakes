{ config, pkgs, ... }:

{
  # Enable touchpad and touchscreen support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      horizontalScrolling = false;
    };
  };
  services.xserver.wacom.enable = true;

  # Touchégg is a multitouch gesture recognizer.
  services.touchegg.enable = true;
}