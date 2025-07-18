{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  users.groups."libvirtd".members = [ "shu" ]; # defined twice

  environment.systemPackages = with pkgs; [
    virt-manager
    wl-clipboard
    python3Packages.pyclip # for waydroid
  ];

  virtualisation.docker.enable = true;
  users.groups."docker".members = [ "shu" ];

  virtualisation.waydroid.enable = true;
}
