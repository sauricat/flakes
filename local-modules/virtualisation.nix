{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  users.groups."libvirtd".members = [ "shu" ]; # defined twice

  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.docker.enable = true;
  users.groups."docker".members = [ "shu" ];
}
