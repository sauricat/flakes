# The Shu NixOS Configuration

These are Shu’s NixOS configuration files.

Specifically, 
- In `home/rime/` are Shu’s [Rime IM](https://rime.im/) configuration files;
- In `home/emacs/` are Shu’s [Emacs](https://www.gnu.org/software/emacs) configuration files.

## Usage

1. Run `build.sh` to build a liveCD, install from an arbitrary external nix enviroment, or upgrade your system configuration. 

2. Or you can simply refer to the following Nix Flake URL `github:sauricat/my-nixos-configuration` since this is a Flaked repository. 

## Structure

- Main entry: `flake.nix`, which includes all the repositories I take advantage of, and all basic configuration of my devices (and a liveCD).

- Directory `dlpt`, `dvm`: These are my 2 devices, virtual and physical. 

- Directory `home`: Configurations concerning [Home Manager](https://github.com/nix-community/home-manager), a necessary suite for NixOS newcomers (just as me owo) to manage their home directory.

- Directory `other-package-managers`, `packages`: Experimental projects will be here. 

- Other directories and files: WYSIWYG.


## References

- [Oxalica’s Configuration](https://github.com/oxalica/nixos-config)

- [Dram’s Configuration](https://github.com/dramforever/config/)

- [Vanilla’s Configuration](https://github.com/VergeDX/config-nixpkgs)

