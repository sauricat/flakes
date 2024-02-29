{ pkgs, ... }:

let x = "--user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0";
    cmd = "busctl get-property ${x} Visible | awk '{ print \\$2 }'";

in
{
  home.file."toggle-keyboard" = {
    target = ".config/squeekboard/toggle-squeekboard";
    executable = true;
    text =
      ''
      #!/usr/bin/env bash
      if [ "$(${cmd})" = "true" ]; then
        busctl call ${x} SetVisible b false
      else
        busctl call ${x} SetVisible b true
      fi
      '';
  };

  systemd.user.services.squeekboard = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      Description = "Virtual Keyboard";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.squeekboard}/bin/squeekboard";
    };
  };
}
