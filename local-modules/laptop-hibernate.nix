{ ... }:
{
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitch=lock
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=hibernate
    IdleActionSec=900
  '';
  systemd.user.services.beforeSleep = {
    description = "Lock screen before sleep";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "forking";
      Environment = "DISPLAY=:0";
      ExecStart = "/run/current-system/sw/bin/loginctl lock-session";
    };
  };
}
