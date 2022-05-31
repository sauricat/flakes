{ 
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-cn.inputs.nixpkgs.follows = "nixpkgs";
    nixos-guix.url = "github:sauricat/nguix"; 
  };

  outputs = inputs@{ self, nixpkgs, nur, nixos-hardware, home-manager, flake-utils, nixos-cn, nixos-guix, ... }: 
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
      packages = (final: prev: import ./functions/auto-recognize-packages.nix final prev);
    };

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
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          { nixpkgs.pkgs = self.legacyPackages."x86_64-linux";
            nixpkgs.overlays = [ nur.overlay nixos-cn.overlay ];
          }
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
