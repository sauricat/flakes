# Reference: https://github.com/Egosummiki/dotfiles/tree/f6577e7c7b9474e05d62c0e6e0d38fee860ea4ea/waybar
# Reference: https://github.com/oxalica/nixos-config/blob/main/home/modules/sway/waybar.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    grim slurp
    dunst
    hyprpaper
    papirus-icon-theme
    alsa-utils brightnessctl upower tlp playerctl
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
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "tray"
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
        format = "{:%Y-%m-%d %H:%M}";
        tooltip = true;
        tooltip-format = "<big>{:%Y-%m-%d %a}</big>\n<tt>{calendar}</tt>";
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
      };

      tray = {
        spacing = 6;
      };
    };
  };
}
