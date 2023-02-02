{
  description = "The Shu NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
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

    epkgs-ligature = { url = "github:mickeynp/ligature.el";
                       flake = false; };
    epkgs-toggle-one-window = { url = "github:manateelazycat/toggle-one-window";
                                flake = false; };
    epkgs-exwm-ns = { url = "github:timor/exwm-ns";
                      flake = false; };

    lsp-nil = { url = "github:oxalica/nil";
                inputs.flake-utils.follows = "flake-utils";
                inputs.nixpkgs.follows = "nixpkgs";
                inputs.rust-overlay.follows = "rust-overlay"; };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, flake-utils, ... }: let
    makeMyConfigurations = conflist: builtins.foldl' (a: b: a // b) { } (builtins.map
      ({ host, system, extraModules? [ ], extraLocalModules? [ ], enableUser? false, enableHomeManager? false }: {
        ${host} = let
          basicModules = [ self.nixosModules.bigcat
                           ./hosts/${host}.nix
                           ./basics.nix
                           ./cache/cachix.nix
                           { networking.hostName = host; } ];
        in nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = { inherit inputs system host; };
          modules = basicModules
                    ++ extraModules
                    ++ builtins.map (name: ./local-modules/${name}.nix) extraLocalModules
                    ++ (if enableHomeManager then [ home-manager.nixosModules.home-manager
                                                    { home-manager.extraSpecialArgs = specialArgs;
                                                      home-manager.useGlobalPkgs = true;
                                                      home-manager.useUserPackages = true;
                                                      home-manager.users.shu = import ./home/home.nix;
                                                      # home-manager.users.oxa = {
                                                      #   imports = [ (inputs.oxalica + "/home/modules/shell") ];
                                                      #   xdg.stateHome = "/home/oxa";
                                                      #   home.stateVersion = "21.05"; };
                                                    } ]
                                             else [ ])
                    ++ (if enableUser then [ ./user.nix ]
                                      else [ ]);
        };
      }) conflist);
  in flake-utils.lib.eachDefaultSystem (system: {
    legacyPackages = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [ "qtwebkit-5.212.0-alpha4" ];
      overlays = builtins.attrValues self.overlays;
    };
  }) // {
    overlays = rec {
      # My packages.
      default = sauricat;
      sauricat = self: super: let
        dirContents = builtins.readDir ./packages;
        genPackage = name: {
          inherit name;
          value = self.callPackage (./packages + "/${name}") { }; };
        names = builtins.attrNames dirContents;
      in builtins.listToAttrs (map genPackage names);

      # My inputs.
      emacs-overlay = inputs.emacs-overlay.overlay;
      nixos-cn = inputs.nixos-cn.overlay;
      rust-overlay = inputs.rust-overlay.overlays.default;
      berberman = inputs.berberman.overlays.default;
      lsp-nil = self: super: { inherit (inputs.lsp-nil.packages.${self.system}) nil; };

      # Many sddm themes requires lib qt-graphical-effects, while the sddm module in nixpkgs does not provide such an
      # option. Therefore I have to override sddm package myself.
      sddm-enable-themes = self: super: {
        sddm = super.sddm.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ super.qt5.qtgraphicaleffects ];
        });
        libsForQt5 = super.libsForQt5 // {
          sddm = super.libsForQt5.sddm.overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [ super.qt5.qtgraphicaleffects ];
          });
        };
        plasma5Packages = super.plasma5Packages // {
          sddm = super.plasma5Packages.sddm.overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [ super.qt5.qtgraphicaleffects ];
          });
        };
      };

      rime-with-plugin = self: super: {
        librime = (super.librime.overrideAttrs (old: { buildInputs = old.buildInputs ++ [ super.luajit ]; })).override { plugins = [ self.librime-lua ]; };
      };
    };
    nixosModules = rec {
      default = smallcat;
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
        host = "iwkr"; # "Iwakura Lain".
        system = "x86_64-linux";
        extraModules = [ ];
        extraLocalModules = [ "localisation"
                              "nokde"
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
                              "mailing" ];
        enableUser = true;
        enableHomeManager = true;
      } {
        host = "wlsn"; # In memorial of my first HOME in CA
        system = "x86_64-linux";
        extraModules = [ ];
        extraLocalModules = [ "localisation"
                              "nokde"
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
                              "mailing" ];
        enableUser = true;
        enableHomeManager = true;
      } {
        host = "vtvp"; # Vultr VPS
        system = "x86_64-linux";
        enableUser = true;
        extraLocalModules = [ "nix" ];
      } {
        host = "livecd";
        system = "x86_64-linux";
        extraLocalModules = [ "kde" "internationalisation" ];
      }
    ];
  };
}
