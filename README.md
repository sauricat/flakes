# The Shu NixOS Configuration

Shu’s NixOS configuration files. 



## Usage

1. Run `functions/build.sh` to build a liveCD, install from an arbitrary external nix enviroment, or upgrade your system configuration. 

2. Or you can simply refer to the following Nix Flake URL `github:sauricat/my-nixos-configuration` since this is a Flaked repository. 

## Structure

- Main entry: `flake.nix`, which includes all the repositories I take advantage of, and all basic configuration of my devices (and a liveCD).

- Directory `dlpt`, `dvm`: These are my 2 devices, virtual or physical. 

- Directory `home`: Configurations concerning [Home Manager](https://github.com/nix-community/home-manager), a necessary suite for NixOS newcomers (just as me owo) to manage their home directory. Especially, in `home/config/ibus-rime/` saves my [Rime IM](https://rime.im/) configuration in yaml format, and can be directly transplanted and builded in another’s device as long as an instance of rime is equipped.  

- Directory `functions`: Some useful files, even separated from the main repository. 

- Directory `other-package-managers`, `packages`: Experimental projects will be here. 

- Other directories and files: WYSIWYG.


## References

- [Oxalica’s Configuration](https://github.com/oxalica/nixos-config)

- [Dram’s Configuration](https://github.com/dramforever/config/)

- [Vanilla’s Configuration](https://github.com/VergeDX/config-nixpkgs)

