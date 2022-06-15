{ 
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = { url = "github:nix-community/emacs-overlay";
                      inputs.nixpkgs.follows = "nixpkgs";
                      inputs.flake-utils.follows = "flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay";
                     inputs.nixpkgs.follows = "nixpkgs";
                     inputs.flake-utils.follows = "flake-utils"; };
    home-manager = { url = "github:nix-community/home-manager";
                     inputs.nixpkgs.follows = "nixpkgs"; }; 
    nixos-cn = { url = "github:nixos-cn/flakes";
                 inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-guix.url = "github:sauricat/nguix";
    oxalica = { url = "github:oxalica/nixos-config";
                inputs.secrets.follows = "blank"; };
  };

  outputs = inputs@{ self, nixpkgs, nur, nixos-hardware, home-manager, flake-utils, nixos-cn, nixos-guix, emacs-overlay, oxalica, ... }:
    let
      overlays = {
        mypackages = ( self: super:
          let
            dirContents = builtins.readDir ./packages;
            genPackage = name: {
              inherit name;
              value = self.callPackage (./packages + "/${name}") {}; };
            names = builtins.attrNames dirContents;
          in builtins.listToAttrs (map genPackage names)
        );
        nur = inputs.nur.overlay;
        emacs-overlay = inputs.emacs-overlay.overlay;
        nixos-cn = inputs.nixos-cn.overlay;
        rust-overlay = inputs.rust-overlay.overlay;
      };
    in
      flake-utils.lib.eachDefaultSystem (system: {
        legacyPackages = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        };
        # packages.home-manager = home-manager.defaultPackage.${system};
      }) 
      // 
      { 
        inherit overlays;

        nixosConfigurations = {
          
          # dvm means Desktop Virtual Machine, an already abandoned configuration
          "dvm" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs.inputs = inputs;
            modules = [
              ./dvm/configuration.nix
              { nixpkgs.pkgs = self.legacyPackages."x86_64-linux"; }
            ];
          };

          # dlpt means Dell LaPTop
          "dlpt" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs.inputs = inputs;
            modules = [
              ./dlpt/configuration.nix
              nixos-hardware.nixosModules.dell-xps-13-7390
              home-manager.nixosModules.home-manager 
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.shu = import ./home/home.nix;
                home-manager.users.oxa = {
                  imports = [ (oxalica + /home/modules/shell) ];
                  xdg.stateHome = /home/oxa; };
                home-manager.extraSpecialArgs = { inherit inputs; };
              }
              { nixpkgs.pkgs = self.legacyPackages."x86_64-linux"; }
              nixos-cn.nixosModules.nixos-cn
              nixos-cn.nixosModules.nixos-cn-registries
              ./cache/cachix.nix
              ./cache/nixos-cn.nix
            ];
          };

          "livecd" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./livecd.nix
            ];
          };

        };
      };
}
