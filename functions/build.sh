#!/usr/bin/env bash
projectDir="$(dirname "$0")"/..
cd $projectDir

# ~~ Interaction ~~
echo -e "Update 'flake.lock'?"
read -p "> (y/n) ... " updateFlake

echo -e "Are you \033[1;31mbuilding a LiveCD (b)\033[0m, \033[1;34minstalling from a LiveCD (i)\033[0m, or just \033[1;32mupdating your configuration (u)\033[0m?" 
read -p "> (b/i/u) ... " flag

if [ "$flag" != "b" ] && [ "$flag" != "B" ]
then
  if [ "$USER" != "root" ]
  then
    exec echo "Please switch to root user."
  fi
  echo -e "Please input your \033[1mhostname\033[0m."
  read -p "> (hostname) ... " hname
fi

# ~~ Action ~~
# 1. update flake.lock
if [ "$updateFlake" = "y" ]
then 
  nix flake update
fi

# 2. LiveCD
if [ "$flag" = "b" ] || [ "$flag" = "B" ]
then
  exec nix build path:.#nixosConfigurations.livecd.config.system.build.isoImage
fi

# 3. normal build
if [ "$flag" = "i" ] || [ "$flag" = "I" ]
then
  # TODO: Use `nixos-generate-config` or some other things to automatically update hardware-configuration.nix 
  # nixos-generate-config --root /mnt
  # cp /mnt/etc/hardware-configuration.nix ...towhere?
  exec nixos-install --flake "path:.#$hname"
elif [ "$flag" = "u" ] || [ "$flag" = "U" ]
then
  exec nixos-rebuild switch --upgrade --flake "path:.#$hname" 
fi

# ~~ Error ~~
echo -e "\033[1;31mInvalid input!\033[0m Exiting the build script..."
