{ inputs, system, lib, ... }:
{
  services.guix-daemon.enable = true;
  environment.systemPackages = [ inputs.nixos-guix.packages.${system}.nixos-guix ];
}
