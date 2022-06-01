#!/usr/bin/env bash
projectDir="$(dirname "$0")"/..
cd $projectDir

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    echo "
Usage:
  $0 [Argument]

Argument:
  -h, --help: Open help page.
  -d, --default: Use default settings. 
"
    exit 1
fi

# ~~ Interaction ~~
if [ "$1" != "-d" ] && [ "$1" != "--default" ]
then
    echo -e "Update 'flake.lock'? (default 'n' by [RET])"
    read -p "> (y/n) ... " updateFlake

    echo -e "\nAre you \033[1;31mbuilding a LiveCD (b)\033[0m, \033[1;34minstalling from a LiveCD (i)\033[0m, or just \033[1;32mupdating your configuration (u)\033[0m? (default 'u' by [RET])" 
    read -p "> (b/i/u) ... " flag

    if [ "$flag" != "b" ] && [ "$flag" != "B" ]
    then
	# if [ "$USER" != "root" ]
	# then
	#     exec echo "Please switch to root user."
	# fi
	echo -e "\nOverride rebuild command? (default 'switch' by [RET])\nFor some options, Check if you have root privilege."
	read -p "> (switch/test/boot/build/dry-build/...) ... " override

	echo -e "\nPlease input your \033[1mhostname\033[0m. (default '$(hostname)' by [RET])"
	read -p "> (hostname) ... " hname
	echo
    fi
fi

# ~~ Auto Completion ~~
if [ "$flag" == "" ] ; then flag="u"; fi
if [ "$override" == "" ] ; then override="switch"; fi
if [ "$hname" == "" ] ; then hname=$(hostname); fi


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
    exec nixos-rebuild $override --flake "path:.#$hname" 
fi

# ~~ Error ~~
echo -e "\033[1;31mInvalid input!\033[0m Exiting the build script..."
exit 1
