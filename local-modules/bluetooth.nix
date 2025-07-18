{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.dbus.packages = [
    pkgs.bluez
    pkgs.blueman
  ];
  systemd.tmpfiles.rules = [
    # See https://github.com/NixOS/nixpkgs/issues/170573
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = [ "systemd-tmpfiles-setup.service" ];

  services.udisks2.enable = true;

}
