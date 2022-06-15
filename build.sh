#!/usr/bin/env bash
cd $(dirname "$0")

if [[ "$1" == "-h" || "$1" == "--help" ]]
then
    exec echo "
Usage:
  $0 [OPTION]

Options:
  -h, --help: Open help page.
  -d, --default: Use default settings. 
"
fi

# ~~ Interaction ~~
if [[ "$1" != "-d" && "$1" != "--default" ]]
then
    echo -e "\nUpdate '\033[1;36mflake\033[0m.lock'? (y/\033[1;4mn\033[0m)"
    read -p ">> " updateFlake

    echo -e "\nWhich \033[1moperation\033[0m do you like to perform?
        \033[31m- build a LiveCD            \033[0m(b)
        \033[33m- install from a LiveCD     \033[0m(i)
        \033[1;32m- update your configuration \033[0m(\033[1;4mu\033[0m)" 
    read -p ">> " flag

    if [[ "$flag" != "b" && "$flag" != "B" ]]
    then
	echo -e "\nWhich rebuild \033[1;34msubcommand\033[0m do you like to use? (\033[1;4mswitch\033[0m/boot/test/build/dry-build/...)"
	read -p ">> " subcommand

	echo -e "\nWhat will be your \033[1;35mideal hostname\033[0m? (\033[1;4m$(hostname)\033[0m/...)"
	read -p ">> " hname
	echo
    fi
fi

# ~~ Auto Completion ~~
if [[ -z "$flag" ]] ; then flag="u"; fi
if [[ -z "$subcommand" ]] ; then subcommand="switch"; fi
if [[ -z "$hname" ]] ; then hname=$(hostname); fi


# ~~ Action ~~
# 1. update flake.lock
if [[ "$updateFlake" == "y" ]]
then 
    nix flake update
fi

# 2. LiveCD
if [[ "$flag" == "b" || "$flag" == "B" ]]
then
    exec nix build path:.#nixosConfigurations.livecd.config.system.build.isoImage
fi

# 3. normal build
if [[ "$flag" == "i" || "$flag" == "I" ]]
then
    # TODO: Use `nixos-generate-config` or some other things to automatically update hardware-configuration.nix 
    # nixos-generate-config --root /mnt
    # cp /mnt/etc/hardware-configuration.nix ...towhere?
    echo -e "Oops! It requires you to \033[1;31mcheck your privilege\033[0m..."
    exec sudo nixos-install --flake "path:.#$hname"
elif [[ "$flag" == "u" || "$flag" == "U" ]]
then
    if [[ "$subcommand" != *"build" ]]
    then
	echo -e "Oops! It requires you to \033[1;31mcheck your privilege\033[0m..."
	exec sudo nixos-rebuild $subcommand --flake "path:.#$hname"
    else
	exec nixos-rebuild $subcommand --flake "path:.#$hname"
    fi
fi

# ~~ Error ~~
echo -e "\n\033[1;31mInvalid input!\033[0m Exiting the build script..."
exit 1
