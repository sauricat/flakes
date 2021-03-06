# The Shu NixOS Configuration

These are Shu’s NixOS configuration files.

Specifically, 
- In `home/rime/` are Shu’s [Rime IM](https://rime.im/) configuration files;
- In `home/emacs/` are Shu’s [Emacs](https://www.gnu.org/software/emacs) configuration files.

## Usage

1. Run `build.sh` to build a liveCD, install from an arbitrary external nix enviroment, or upgrade your system configuration. 

2. Or you can simply refer to the following Nix Flake URL `github:sauricat/flakes` since this is a Flaked repository.

## Flake Outputs

```
├───legacyPackages (omitted)
├───nixosConfigurations
│   ├───dlpt: NixOS configuration
│   └───livecd: NixOS configuration
├───nixosModules
│   ├───bigcat: NixOS module (! contains all overlays and configs)
│   └───smallcat: NixOS module (! only contains modules and packages)
└───overlays
    ├───berberman: Nixpkgs overlay
    ├───emacs-overlay: Nixpkgs overlay
    ├───nixos-cn: Nixpkgs overlay
    ├───nur: Nixpkgs overlay
    ├───rust-overlay: Nixpkgs overlay
    └───sauricat: Nixpkgs overlay
```

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

