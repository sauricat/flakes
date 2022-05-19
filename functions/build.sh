#!/usr/bin/env bash
cd "$(dirname "$0")"/..

echo -e "Are you \033[1;31mbuilding a LiveCD (b)\033[0m, \033[1;34minstalling from a LiveCD (i)\033[0m, or just \033[1;32mupdating your configuration (u)\033[0m?" 
read -p "> (b/i/u) ... " flag 

# build a LiveCD
if [ "$flag" = "b" ] || [ "$flag" = "B" ]
then
  exec nix build path:.#nixosConfigurations.livecd.config.system.build.isoImage
fi

# normal build
if [ "$USER" != "root" ]
then
  exec echo "Please switch to root user."
fi

echo -e "Please input your \033[1mhostname\033[0m."
read -p "> (hostname) ... " hname
if [ "$flag" = "i" ] || [ "$flag" = "I" ]
then
  # TODO: Use `nixos-generate-config` or some other things to automatically update hardware-configuration.nix 
  # nixos-generate-config --root /mnt
  # cp /mnt/etc/hardware-configuration.nix ...towhere?
  exec nixos-install --flake "path:.#$hname"
elif [ "$flag" = "u" ] || [ "$flag" = "U" ]
then
  exec nixos-rebuild switch --flake "path:.#$hname"
fi

echo -e "\033[1,31mInvalid input!\033[0m Exiting the build script..."
