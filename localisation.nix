# Named localisation, but actually services stuffs. 

{ config, pkgs, ... }:

{
  # Localisation and X11

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "lt_LT.UTF-8"; # The hometown of Emmanuel Levinas, yyyy-MM-dd hh:mm 
  };
  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [
    anthy rime bamboo
    typing-booster ];
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl"; # included xkbOption "eurosign:5"
  services.xserver.xkbOptions = "caps:none";  # /usr/share/X11/xkb/rules/evdev.lst

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = "load-module module-switch-on-connect";
  
  powerManagement.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = false;
  services.xserver.libinput.touchpad.tapping = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.horizontalScrolling = false;
  services.touchegg.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.dbus.packages = [ pkgs.bluez pkgs.blueman ];
  systemd.tmpfiles.rules = [ # See https://github.com/NixOS/nixpkgs/issues/170573
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
    
  # Nix configuration
  nix = {
    package = pkgs.nixFlakes; 
    extraOptions = "experimental-features = nix-command flakes";
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "Sun 01:00";
    };
  };

  nixpkgs.config.allowUnfree = true;

}
