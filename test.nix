{ pkgs, ... }:
{
  imports = [
    ./packages/asusctl/asusd.nix
  ];
  services.asusd.enable = true;
  environment.systemPackages = with pkgs; [
    wpsoffice
    qqmusic
    #pacman
    asusctl
  ];
}
