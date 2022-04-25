#!/usr/bin/env fish
if [ "$USER" = "root" ]
  export NIXOS_CONFIG=$PWD/configuration.nix
  nixos-rebuild switch
else
  echo Please switch to root user. 
end
