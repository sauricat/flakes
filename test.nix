{ pkgs, ... }:
{
  imports = [
    # ./packages/asusctl/asusd.nix
  ];
  environment.systemPackages = with pkgs; [
    wpsoffice
    qqmusic
    #pacman
    asusctl
  ];
}
