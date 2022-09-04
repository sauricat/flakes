{ ... }:
{
  services.logind.extraConfig = ''
    HandlePowerKey=poweroff
    HandleLidSwitch=lock
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=ignore
  '';
}
