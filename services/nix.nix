{ pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nixFlakes; 
    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
      download-attempts = 5
      connect-timeout = 15
      stalled-download-timeout = 10
    '';
    
    registry = {
      nixpkgs = {
        from = { id = "nixpkgs"; type = "indirect"; };
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "Sun 01:00";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
