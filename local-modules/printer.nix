{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };
  environment.systemPackages = with pkgs; [ system-config-printer ];
}
