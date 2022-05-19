{
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-cn.inputs.nixpkgs.follows = "nixpkgs";
    nixos-guix.url = "github:sauricat/nixos-guix"; # originnally e0thancedwards8/nixos-guix
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, nixos-cn, nixos-guix, ... }: let 
    system = "x86_64-linux";
  in
  { 
    nixosConfigurations = {
      
      # dvm means Desktop Virtual Machine
      "dvm" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./dvm/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.shu = import ./home/home.nix;
          }
        ];
      };

      # dlpt means Dell LaPTop
      "dlpt" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./dlpt/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-7390
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.shu = import ./home/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs system; };
          }
          nixos-cn.nixosModules.nixos-cn
          nixos-cn.nixosModules.nixos-cn-registries
          ./cache/cachix.nix
          ./cache/nixos-cn.nix
        ];
      };

      "livecd" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./livecd.nix
        ];
      };

    };
  };
}
