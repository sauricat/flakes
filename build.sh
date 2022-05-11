#!/usr/bin/env bash
if [ "$USER" = "root" ]
then
  cd "$(dirname "$0")"
  echo Please input hostname.
  read hname
  # export NIXOS_CONFIG=$PWD/configuration.nix
  nixos-rebuild switch --flake "path:.#$hname"
else
  echo Please switch to root user. 
fi
