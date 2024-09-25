{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.protonmail-bridge pkgs.gnome-keyring ];
  services.gnome.gnome-keyring.enable = true;
  systemd.user.services.protonmail-bridge = {
    description = "Protonmail Bridge";
    wantedBy = [ "default.target" ];
    path = [ pkgs.pass ];
    serviceConfig = {
      Restart = "on-failure";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
    };
  };
}
