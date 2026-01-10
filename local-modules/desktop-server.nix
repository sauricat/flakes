{ ... }:
{
  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleLidSwitch = "lock";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
  };
}
