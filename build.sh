#!/usr/bin/env fish
if [ "$USER" = "root" ]
  export NIXOS_CONFIG=$PWD/configuration.nix
  nixos-rebuild switch --flake path:.
else
  echo Please switch to root user. 
end
