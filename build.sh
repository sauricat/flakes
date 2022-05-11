#!/usr/bin/env bash
cd "$(dirname "$0")"

echo "Are you building a LiveCD, installing from a LiveCD, or just updating your configuration? (b/i/u)"
read flag

# build a LiveCD
if [ "$flag" = "b" ] || [ "$flag" = "B" ]
then
  exec nix build path:.#nixosConfigurations.livecd.config.system.build.isoImage
fi

# normal build
if [ "$USER" != "root" ]
then
  exec echo Please switch to root user. 
fi

echo "Please input hostname."
read hname
if [ "$flag" = "i" ] || [ "$flag" = "I" ]
then
  exec nixos-install --flake "path:.#$hname"
elif [ "$flag" = "u" ] || [ "$flag" = "U" ]
then
  exec nixos-rebuild switch --flake "path:.#$hname"
fi

echo "Invalid input! Exiting the build script..."
