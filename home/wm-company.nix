{ pkgs, lib, ... }:
let
  i3lock-shu = pkgs.writeShellApplication {
    name = "i3lock-shu";
    runtimeInputs = with pkgs; [ gnugrep imagemagick xorg.xrandr i3lock ];
    text = builtins.readFile ./shell/i3lock-shu.sh;
    checkPhase = ""; # Don't do check.
  };
in
{
  home.packages = with pkgs; [
    maim xclip # for printing screen and copying it to clipboard
    gtk3 # for gtk-launch
    alsa-utils brightnessctl upower tlp playerctl # for epkgs.desktop-environment
    networkmanagerapplet
    i3lock-shu xautolock
  ];

  # A simple launcher
  programs.rofi = {
    enable = true;
    theme = "Arc";
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun,run,window,filebrowser";
    };
  };

  programs.lf = {
    enable = true;
    extraConfig = "set previewer ${pkgs.pistol}/bin/pistol";
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  # Avoid screen tearing
  services.picom = {
    enable = true;
    fade = true;
  };

  systemd.user.services.polybar = lib.mkOverride 10 { }; # let exwm start it.
  services.polybar =
    let
      colors = {
        background = "#d6d4d4";
        background-alt = "#e4e4e4";
        foreground = "#000000";
        primary = "#4271ae";
        secondary = "#c82829";
        alert = "#c82829";
        disabled = "#8a8787";
      };
      find-ibus-engine = pkgs.writeShellScript "find-ibus-engine.sh" ''
        IBUS_RAW=$(${pkgs.ibus}/bin/ibus engine)
        IBUS_ENGINE=$(echo $IBUS_RAW | ${pkgs.gawk}/bin/awk -F ':' '{print $1}')
        IBUS_LAYOUT=$(echo $IBUS_RAW | ${pkgs.gawk}/bin/awk -F ':' '{print $2}')
        IBUS_LAYOUT_VARIANT=$(echo $IBUS_RAW | ${pkgs.gawk}/bin/awk -F ':' '{print $3}')

        ENGINE_ICON="🚎"
        LAYOUT_ICON=""

        if [ "$IBUS_ENGINE" = "xkb" ]
        then
            IBUS_ENGINE=""
        fi
        OUTPUT="$ENGINE_ICON $IBUS_ENGINE"

        if [ -n "$IBUS_LAYOUT_VARIANT" ] && [ "$IBUS_LAYOUT_VARIANT" != "\n" ]
        then
            OUTPUT="$OUTPUT $LAYOUT_ICON $IBUS_LAYOUT - $IBUS_LAYOUT_VARIANT"
        else
            OUTPUT="$OUTPUT $LAYOUT_ICON $IBUS_LAYOUT"
        fi

        echo $OUTPUT
        exit 0
      '';
    in
    {
      enable = true; # how to let exwm enable it?
      package = pkgs.polybarFull;
      script = "polybar &";
      extraConfig = ''
        [bar/example]
        width = 100%
        height = 24pt
        radius = 0

        ; dpi = 96

        background = ${colors.background}
        foreground = ${colors.foreground}

        line-size = 3pt

        border-size = 0pt
        border-color = ${colors.background}

        padding-left = 0
        padding-right = 1

        module-margin = 1

        separator = |
        separator-foreground = ${colors.disabled}

        font-0 = monospace:size=14;1
        font-1 = Noto Color Emoji:scale=10x;2

        modules-left = xworkspaces
        modules-center = date
        modules-right = memory cpu wlan eth pulseaudio ibus battery

        cursor-click = pointer
        cursor-scroll = ns-resize

        enable-ipc = true

        tray-position = left

        wm-restack = generic
        ; wm-restack = bspwm
        ; wm-restack = i3

        ; override-redirect = true

        [module/xworkspaces]
        type = internal/xworkspaces

        label-active = EXWM Workspace %name%: with %nwin% desktop app(s)
        label-active-background = ${colors.background-alt}
        label-active-underline= ${colors.primary}
        label-active-padding = 1

        label-occupied = #%name%+%nwin%
        label-occupied-padding = 1

        label-urgent = #%name%+%nwin%
        label-urgent-background = ${colors.alert}
        label-urgent-padding = 1

        label-empty = #%name%+%nwin%
        label-empty-foreground = ${colors.disabled}
        label-empty-padding = 1

        [module/filesystem]
        type = internal/fs
        interval = 25

        mount-0 = /

        label-mounted = %{F${colors.primary}}%mountpoint%%{F-} %percentage_used%%

        label-unmounted = %mountpoint% not mounted
        label-unmounted-foreground = ${colors.disabled}

        [module/pulseaudio]
        type = internal/pulseaudio

        format-volume-prefix = "VOL "
        format-volume-prefix-foreground = ${colors.primary}
        format-volume = <label-volume>

        label-volume = %percentage%%

        label-muted = muted
        label-muted-foreground = ${colors.disabled}

        [module/memory]
        type = internal/memory
        interval = 2
        format-prefix = "RAM "
        format-prefix-foreground = ${colors.primary}
        label = %percentage_used:2%%

        [module/cpu]
        type = internal/cpu
        interval = 2
        format-prefix = "CPU "
        format-prefix-foreground = ${colors.primary}
        label = %percentage:2%%

        [network-base]
        type = internal/network
        interval = 5
        format-connected = <label-connected>
        format-disconnected = <label-disconnected>
        label-disconnected = %{F${colors.primary}}%ifname%%{F-} disconnected

        [module/wlan]
        inherit = network-base
        interface-type = wireless
        label-connected = %{F${colors.primary}}%ifname%%{F-} %essid% %local_ip%

        [module/eth]
        inherit = network-base
        interface-type = wired
        label-connected = %{F${colors.primary}}%ifname%%{F-} %local_ip%

        [module/battery]
        type = internal/battery
        label-full = 🔌 %percentage%%
        label-charging = 🔌 %percentage%%
        label-discharging = 🔋 %percentage%%
        label-low = 🪫 %percentagee%%

        full-at = 100
        low-at = 20

        ; $ ls -1 /sys/class/power_supply/
        battery = BAT0
        adapter = ADP1
        poll-interval = 5

        [module/date]
        type = internal/date
        interval = 1

        date = %Y-%m-%d %H:%M
        ; date-alt =

        label = %date%
        label-foreground = ${colors.primary}

        [settings]
        screenchange-reload = true
        pseudo-transparency = true

        [module/ibus]
        type = custom/script

        exec = ${find-ibus-engine} &
        ; you need to run ibus-daemon first for the script to work
        ; exec-if = ${pkgs.procps}/bin/pgrep -x ibus-daemon

        tail = true
      '';
    };
}
