{ ... }:
{
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=suspend
    IdleActionSec=600
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
