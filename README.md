# The Shu NixOS Configuration

Shu’s nixos configuration files. 

You can also simply enter into the `home/config/ibus-rime/` directory to get my Rime configuration. 


## Usage

Run `functions/build.sh` to build a liveCD, install from an arbitrary external nix enviroment, or upgrade your system configuration. 


## Structure

- Main entry: `flake.nix`, which includes all the repositories I take advantage of, and all basic configuration of my devices (and a liveCD).

- Directory `dlpt`, `dvm`: These are my 2 devices, virtual or physical. 

- Directory `functions`: Some useful files, even separated from the main repository. 

- Directory `other-package-managers`, `packages`: Experimental projects will be here. 

- Other directoryies and files: WYSIWYG.


## References

- [Oxalica’s Configuration](https://github.com/oxalica/nixos-config)

- [Dram’s Configuration](https://github.com/dramforever/config/)

- [Vanilla’s Configuration](https://github.com/VergeDX/config-nixpkgs)

