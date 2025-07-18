{
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oxalica = {
      url = "github:oxalica/nixos-config";
      flake = false;
    };
    tree-sitter-nix-oxa = {
      url = "github:oxalica/tree-sitter-nix";
      flake = false;
    };

    epkgs-ligature = {
      url = "github:mickeynp/ligature.el";
      flake = false;
    };
    epkgs-toggle-one-window = {
      url = "github:manateelazycat/toggle-one-window";
      flake = false;
    };
    epkgs-typst-ts-mode = {
      url = "github:kaction-emacs/typst-ts-mode";
      flake = false;
    };

    lsp-nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      flake-utils,
      lanzaboote,
      nur,
      ...
    }:
    let
      makeMyConfigurations =
        conflist:
        builtins.foldl' (a: b: a // b) { } (
          builtins.map (
            {
              host,
              system,
              extraModules ? [ ],
              extraLocalModules ? [ ],
              enableUser ? false,
              enableHomeManager ? false,
            }:
            {
              ${host} =
                let
                  basicModules = [
                    self.nixosModules.bigcat
                    ./hosts/${host}.nix
                    ./basics.nix
                    ./cache/cachix.nix
                    { networking.hostName = host; }
                  ];
                in
                nixpkgs.lib.nixosSystem rec {
                  inherit system;
                  specialArgs = { inherit inputs system host; };
                  modules =
                    basicModules
                    ++ extraModules
                    ++ builtins.map (name: ./local-modules/${name}.nix) extraLocalModules
                    ++ (
                      if enableHomeManager then
                        [
                          home-manager.nixosModules.home-manager
                          {
                            home-manager.extraSpecialArgs = specialArgs;
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.backupFileExtension = "backup";
                            home-manager.users.shu = import ./home/home.nix;
                          }
                        ]
                      else
                        [ ]
                    )
                    ++ (if enableUser then [ ./user.nix ] else [ ]);
                };
            }
          ) conflist
        );
    in
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          # "qtwebkit-5.212.0-alpha4"
        ];
        overlays = builtins.attrValues self.overlays;
      };
    })
    // {
      overlays = rec {
        # My packages.
        default = sauricat;
        sauricat =
          self: super:
          let
            dirContents = builtins.readDir ./packages;
            genPackage = name: {
              inherit name;
              value = self.callPackage (./packages + "/${name}") { };
            };
            names = builtins.attrNames dirContents;
          in
          builtins.listToAttrs (map genPackage names);

        # My inputs.
        emacs-overlay = inputs.emacs-overlay.overlay;
        rust-overlay = inputs.rust-overlay.overlays.default;
        lsp-nil = self: super: { inherit (inputs.lsp-nil.packages.${self.system}) nil; };
        nur = self: super: {
          nur = import inputs.nur {
            nurpkgs = self;
            pkgs = self;
          };
        };

      };
      nixosModules = rec {
        default = smallcat;
        smallcat =
          { ... }:
          {
            nixpkgs.overlays = [ self.overlays.sauricat ];
            imports = [ ./modules ];
          };
        bigcat =
          { system, ... }:
          {
            nixpkgs.pkgs = self.legacyPackages.${system};
            imports = [ ./modules ];
          };
      };
      nixosConfigurations = makeMyConfigurations [
        {
          host = "iwkr"; # "Iwakura Lain".
          system = "x86_64-linux";
          extraModules = [ nur.modules.nixos.default ];
          extraLocalModules = [
            "localisation"
            "kde"
            "nokde" # awkward
            "bluetooth"
            "multitouch"
            "network"
            "virtualisation"
            "nix"
            "console-l10n"
            # "guix"
            "laptop-sleep"
            "steam"
            "printer"
            "mailing"
          ];
          enableUser = true;
          enableHomeManager = true;
        }
        {
          host = "wlsn"; # In memorial of my first HOME in CA
          system = "x86_64-linux";
          extraModules = [
            lanzaboote.nixosModules.lanzaboote
            nur.modules.nixos.default
          ];
          extraLocalModules = [
            "localisation"
            "nokde"
            "kde"
            "bluetooth"
            "multitouch"
            "network"
            "virtualisation"
            "nix"
            "console-l10n"
            # "guix"
            "desktop-server"
            "steam"
            "printer"
            "mailing"
          ];
          enableUser = true;
          enableHomeManager = true;
        }
        {
          host = "vtvp"; # Vultr VPS
          system = "x86_64-linux";
          enableUser = true;
          extraLocalModules = [ "nix" ];
        }
        {
          host = "hyvp"; # hyVPS
          system = "x86_64-linux";
          enableUser = true;
          extraLocalModules = [ "nix" ];
        }
        {
          host = "livecd";
          system = "x86_64-linux";
          extraLocalModules = [
            "kde"
            "internationalisation"
          ];
        }
      ];
    };
}
