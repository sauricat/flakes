{ lib, pkgs, ... }:
{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.session = lib.singleton {
    name = "exwm-plasma";
    start = pkgs.writeShellScript "start-exwm-plasma" ''
      if [[ -f $HOME/.xsessions/exwm-plasma.xsession ]]
      then
        exec ${pkgs.runtimeShell} -c $HOME/.xsessions/exwm-plasma.xsession
      else
        exit 1
      fi
    '';
  };

  environment.systemPackages = with pkgs; [
    plasma-browser-integration
    plasma5Packages.bismuth
  ];
}
