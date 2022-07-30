{ ... }:
{
  services.logind.extraConfig = ''
    HandlePowerKey=poweroff
    HandleLidSwitch=lock
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=poweroff
    IdleActionSec=1800
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
