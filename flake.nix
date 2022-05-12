{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, ... }: { 
    nixosConfigurations = {
      "dvm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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

      "dlpt" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./dlpt/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-7390
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

      "livecd" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./livecd.nix
        ];
      };

    };
  };
}