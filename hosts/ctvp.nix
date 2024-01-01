{ modulesPath, ... }:
{

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda3"; fsType = "ext4"; };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtqhzrEH5VnSSxcLn7MJKbCw7QFhQmX8hkSmsEMq8/I shu@iwkr'' ];

  services.tailscale.enable = true;

  security.sudo.wheelNeedsPassword = false;
  networking.firewall.enable = false;

}
