{
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-cn = {
      url = "github:nixos-cn/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, nixos-cn, ... }: let 
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

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      # dlpt means Dell LaPTop
      "dlpt" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./dlpt/configuration.nix

          nixos-cn.nixosModules.nixos-cn
          nixos-cn.nixosModules.nixos-cn-registries
          ./services/nixos-cn.nix

          nixos-hardware.nixosModules.dell-xps-13-7390
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.shu = import ./home/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs system; };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
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
