{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  users.groups."libvirtd".members = [ "shu" ];

  environment.systemPackages = with pkgs; [ virt-manager ];
}