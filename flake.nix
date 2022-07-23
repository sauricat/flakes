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
    epkgs-toggle-one-window = { url = "github:manateelazycat/toggle-one-window";
                                flake = false; };
    epkgs-exwm-ns = { url = "github:timor/exwm-ns";
                      flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, flake-utils, ... }: let
    makeMyConfigurations = conflist: builtins.foldl' (a: b: a // b) { } (builtins.map
      ({ host, system, extraModules? [ ], enableUser? false, enableHomeManager? false }: {
        ${host} = nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = extraModules ++ [
            self.nixosModules.bigcat
            ./hosts/${host}.nix
            ./basics.nix
            ./cache/cachix.nix
            { networking.hostName = host; }
          ] ++ (if enableHomeManager
                then [ home-manager.nixosModules.home-manager
                       {
                         home-manager.extraSpecialArgs = specialArgs;
                         home-manager.useGlobalPkgs = true;
                         home-manager.useUserPackages = true;
                         home-manager.users.shu = import ./home/home.nix;
                         home-manager.users.oxa = {
                           imports = [ (inputs.oxalica + "/home/modules/shell") ];
                           xdg.stateHome = "/home/oxa";
                           home.stateVersion = "21.05"; };
                       }
                     ]
                else [ ])
            ++ (if enableUser
                then [ ./user.nix ]
                else [ ]);
        };
      }) conflist);
    nixosPrivate = builtins.map (name: ./services/${name}.nix);
  in flake-utils.lib.eachDefaultSystem (system: {
    legacyPackages = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = builtins.attrValues self.overlays;
    };
  }) // {
    overlays = {
      sauricat = self: super:
        let dirContents = builtins.readDir ./packages;
            genPackage = name: {
              inherit name;
              value = self.callPackage (./packages + "/${name}") { }; };
            names = builtins.attrNames dirContents;
        in builtins.listToAttrs (map genPackage names);
      nur = inputs.nur.overlay;
      emacs-overlay = inputs.emacs-overlay.overlay;
      nixos-cn = inputs.nixos-cn.overlay;
      rust-overlay = inputs.rust-overlay.overlays.default;
      berberman = inputs.berberman.overlay;
    };
    nixosModules = {
      smallcat = { ... }: {
        nixpkgs.overlays = [ self.overlays.sauricat ];
        imports = [ ./modules ];
      };
      bigcat = { system, ... }: {
        nixpkgs.pkgs = self.legacyPackages.${system};
        imports = [ ./modules ];
      };
    };
    nixosConfigurations = makeMyConfigurations [
      {
        host = "dlpt";
        system = "x86_64-linux";
        extraModules = nixosPrivate [
          "localisation"
          "bluetooth"
          "multitouch"
          "network"
          "virtualisation"
          "nix"
          "console-l10n"
          "guix"
          "laptop-sleep"
          "steam"
        ] ++ [
          nixos-hardware.nixosModules.dell-xps-13-7390
        ];
        enableUser = true;
        enableHomeManager = true;
      } {
        host = "livecd";
        system = "x86_64-linux";
        extraModules = nixosPrivate [
          "localisation"
          "network"
        ];
      }
    ];
  };
}
