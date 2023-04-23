{ config, pkgs, ... }:

{
  users.users = {
    shu = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "lp" "scanner" ];
      shell = pkgs.fish;
      homeMode = "755";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtqhzrEH5VnSSxcLn7MJKbCw7QFhQmX8hkSmsEMq8/I shu@iwkr"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQOJJrevWnZsc6KAeQFFRDy7Seun+50d/tjAMLpVlvV shu@wlsn"
      ];
    };
    oxa = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYl9bIMoMrs8gWUmIAF42mGnKVxqY6c+g2gmE6u2E/B oxa@invar"
      ];
    };
    kuniklo = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpbFRWmtQiIYuoZ4JCjEFd2thcT+pMkeh3xzugLHGOd kuniklo@Pod042A"
      ];
    };
  };
  nix.settings.trusted-users = [ "@wheel" ];
  nix.sshServe = {
    enable = if config.networking.hostName == "wlsn" then true else false;
    keys = config.users.users.shu.openssh.authorizedKeys.keys
           ++ config.users.users.oxa.openssh.authorizedKeys.keys
           ++ config.users.users.kuniklo.openssh.authorizedKeys.keys;
  };
}
