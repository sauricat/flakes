# Reference: https://github.com/Egosummiki/dotfiles/tree/f6577e7c7b9474e05d62c0e6e0d38fee860ea4ea/waybar
# Reference: https://github.com/oxalica/nixos-config/blob/main/home/modules/sway/
{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    grim slurp
    dunst
    hyprpaper
    papirus-icon-theme
    alsa-utils brightnessctl upower tlp playerctl
    swayidle
    squeekboard
  ];

  programs.rofi = {
    enable = true;
    theme = "awsi";
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,window,filebrowser";
      show-icons = true;
      icon-theme = "Papirus-Light";
    };
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      image = "~/clash-configuration/lock-screen-picture";
      scaling = "fill";
      indicator-idle-visible = true;
      clock = true;
      datestr = "%Y-%m-%d %A";
      show-failed-attempts = true;
    };
  };

  programs.waybar = {
    enable = true;
    style = pkgs.substituteAll {
      src = ./hypr/waybar.css;
      fontSize = 14; # * config.wayland.dpi / 96;
    };
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 24; # * config.wayland.dpi / 96;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/mode"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "tray"
        "idle-inhibitor"
        "network"
        "pulseaudio"
        # "cpu"
        # "memory"
        "battery"
      ];

      "hyprland/workspaces" = {
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      "hyprland/window" = {
        max-length = 25;
        separate-outputs = true;
      };

      clock = {
        interval = 1;
        format = "{:%Y-%m-%d %H:%M %Z}";
        tooltip = true;
        tooltip-format = "<big>{:%Y-%m-%d %A}</big>\n<tt>{calendar}</tt>";
        on-click = "busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true";
        on-click-right = "busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false";
      };
      cpu = {
        interval = 1;
        format = " {usage}%";
      };

      memory = {
        interval = 1;
        format = " {used:0.1f}/{total:0.1f}+{swapUsed:0.1f}G";
      };

      battery = {
        bat = "BAT0";
        format = "{icon} {capacity}%";
        states = {
          warning = 30;
          critical = 15;
        };
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-ethernet = " ";
        format-wifi = " {essid} {signalStrength}%";
        format-linked = " {ifname}";
        format-disconnected = " ";
        on-click = ''emacsclient -c -e "(progn (multi-vterm) (vterm-send-string \"nmtui\n\"))"'';
      };

      pulseaudio = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = " {format_source}";
        format-source = "  {volume}%";
        format-source-muted = "";
        format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
        };
        scroll-step = 2.0;
        on-click = "pkill -f -x ${pkgs.pavucontrol}/bin/pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol";
        on-click-right = ''emacsclient -e "(desktop-environment-toggle-mute)"'';
      };

      idle_inhibitor = {
  	    format = "{icon}";
  	    format-icons = {
  		    activated = "";
  		    deactivated = "";
  	    };
      };

      tray = {
        spacing = 6;
      };
    };
  };
}
