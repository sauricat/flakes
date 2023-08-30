# Ref: https://gitlab.com/NickCao/flakes/-/blob/master/nixos/local/home.nix
# Ref: https://github.com/oxalica/nixos-config/blob/main/home/modules/sway/default.nix
{ lib, pkgs, config, my, ... }:
let
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";

  terminal = "${pkgs.alacritty}/bin/alacritty";

  sway = config.wayland.windowManager.sway.package;

  app = cmd: "${lib.getExe my.pkgs.systemd-run-app} ${cmd}";

in
{
  imports = [
    ./waybar.nix
  ];

  home.packages = (with pkgs; [
    waypipe
    pavucontrol
    grim
    slurp
    sway-contrib.grimshot
  ]) ++ (with pkgs.libsForQt5; [
    # From plasma5.
    dolphin
    dolphin-plugins
    ffmpegthumbs
    kdegraphics-thumbnailers
    kio
    kio-extras
    ark
  ]);

  home.pointerCursor = {
    package = pkgs.breeze-qt5;
    name = "breeze_cursors";
    size = 24; # Make cursor in each window the same size.
    gtk.enable = true;
  };


  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 900; # 15min
        command = "${lib.getExe config.programs.swaylock.package} --grace=5";
      }
      {
        timeout = 905;
        command = ''${sway}/bin/swaymsg "output * power off"'';
        resumeCommand = ''${sway}/bin/swaymsg "output * power on"'';
      }
    ];
    events = [
      {
        event = "lock";
        command = lib.getExe config.programs.swaylock.package;
      }
      # Not implemented yet: https://github.com/swaywm/swaylock/pull/237
      # { event = "unlock"; command = ""; }
      {
        event = "before-sleep";
        command = "/run/current-system/systemd/bin/loginctl lock-session";
      }
    ];
  };
  systemd.user.services.swayidle.Service.Slice = "session.slice";

  systemd.user.targets.sway-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
}
