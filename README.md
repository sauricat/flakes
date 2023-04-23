# The Shu NixOS Configuration

These are Shu’s NixOS configuration files.

Specifically, 
- In `home/rime/` are Shu’s [Rime IM](https://rime.im/) configuration files;
- In `home/emacs/` are Shu’s [Emacs](https://www.gnu.org/software/emacs) configuration files.

## Use Packages and Modules Provided by Me

My package overlay is in `outputs.overlays.sauricat`.

My modules, including the overlay, are in `outputs.nixosModules.smallcat`.

## Usage

1. Run `build.sh` to build a liveCD, install from an arbitrary external nix enviroment, or upgrade your system configuration. 

2. Or you can simply refer to the following Nix Flake URL `github:sauricat/flakes` since this is a Flaked repository.

## Directory Structure

- Main entry: `flake.nix`, which includes all the repositories I take advantage of, and all basic configuration of my devices (and a liveCD).

- Directory `hosts`: Device-specific configuration. 

- Directory `home`: Configurations concerning [Home Manager](https://github.com/nix-community/home-manager), a necessary suite for NixOS newcomers (just as me owo) to manage their home directory.

- Directory `modules`, `packages`: Experimental projects will be here. They are the two parts of flake output `nixosModules.smallcat`.

- Other directories and files: WYSIWYG.

## References

- [Oxalica’s Configuration](https://github.com/oxalica/nixos-config)

- [Dram’s Configuration](https://github.com/dramforever/config/)

- [Vanilla’s Configuration](https://github.com/VergeDX/config-nixpkgs)

## Commit Message Convention (Test, Effective 2023-04-23)
- ア Update Modules, Components, or `flake.lock`
- か Add Components or Modules, not only Files
- け Remove Components or Modules, not only Files
- 直 Tweak, Modify or Fix
- 移 Move/Separate Modules
- テ Test
- バ Backup
- 文 Tweak documentation
- 合 Merge commit of pull request

