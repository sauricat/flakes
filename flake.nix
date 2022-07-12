{
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat";
                     flake = false; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay";
                      inputs.nixpkgs.follows = "nixpkgs";
                      inputs.flake-utils.follows = "flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay";
                     inputs.nixpkgs.follows = "nixpkgs";
                     inputs.flake-utils.follows = "flake-utils"; };
    home-manager = { url = "github:nix-community/home-manager";
                     inputs.nixpkgs.follows = "nixpkgs";
                     inputs.utils.follows = "flake-utils"; };
    nixos-cn = { url = "github:nixos-cn/flakes";
                 inputs.nixpkgs.follows = "nixpkgs";
                 inputs.flake-utils.follows = "flake-utils"; };
    berberman = { url = "github:berberman/flakes";
                  inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-guix = { url = "github:sauricat/nguix";
                   inputs.nixpkgs.follows = "nixpkgs";
                   inputs.flake-compat.follows = "flake-compat"; };
    oxalica = { url = "github:oxalica/nixos-config";
                # inputs.secrets.follows = "blank";
                flake = false; };
    tree-sitter-nix-oxa = { url = "github:oxalica/tree-sitter-nix";
                            flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, flake-utils, ... }:
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
      overlays = {
        sauricat = self: super:
          let dirContents = builtins.readDir ./packages;
              genPackage = name: {
                inherit name;
                value = self.callPackage (./packages + "/${name}") {}; };
              names = builtins.attrNames dirContents;
          in builtins.listToAttrs (map genPackage names);
        nur = inputs.nur.overlay;
        emacs-overlay = inputs.emacs-overlay.overlay;
        nixos-cn = inputs.nixos-cn.overlay;
        rust-overlay = inputs.rust-overlay.overlays.default;
        berberman = inputs.berberman.overlay;
      };
      nixosModules.smallcat = { ... }: {
        nixpkgs.overlays = [ self.overlays.sauricat ];
        imports = [ ./modules ];
      };
      nixosModules.bigcat = { ... }: {
        nixpkgs.pkgs = self.legacyPackages."x86_64-linux";
        imports = [ ./modules ];
      };
      nixosConfigurations = {
        # dvm means Desktop Virtual Machine, an already abandoned configuration
        "dvm" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./dvm/configuration.nix
            self.nixosModules.bigcat
          ];
        };

        # dlpt means Dell LaPTop
        "dlpt" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./dlpt/configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-7390
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.shu = import ./home/home.nix;
              home-manager.users.oxa = {
                imports = [ (inputs.oxalica + /home/modules/shell) ];
                xdg.stateHome = /home/oxa;
                home.stateVersion = "21.05"; };
            }
            self.nixosModules.bigcat
            ./cache/cachix.nix
            # ./cache/nixos-cn.nix
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
