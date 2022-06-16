# asusd daemon.

{ config, lib, pkgs, ... }:
let
  cfg = config.services.asusd;
in
{
  options = {
    services.asusd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        descripton = ''
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    
  };

  meta.maintainers = pkgs.asusctl.meta.maintaners;
}
