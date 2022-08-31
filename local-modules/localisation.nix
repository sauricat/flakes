# Named localisation, but actually services stuffs, including X11 server.
{ pkgs, lib, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "lt_LT.UTF-8"; # Emmanuel Lévinas's hometown.
      LC_CTYPE = "ja_JP.UTF-8";
    };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        typing-booster
        anthy
        rime
        bamboo
        libthai
        uniemoji
      ];
    };
  };
  console = {
    font = lib.mkOverride 900 "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
    ark
    filelight
  ];
  programs.fish.enable = true;
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Some defaults, override "basics.nix"
  programs.gnupg.agent.pinentryFlavor = lib.mkOverride 900 "qt";
  programs.command-not-found.enable   = lib.mkOverride 900 true;
  services.flatpak.enable             = lib.mkOverride 900 true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols

      # CJKV
      noto-fonts-cjk
      hanazono
      source-han-sans source-han-serif source-han-mono
      wqy_microhei wqy_zenhei
      sarasa-gothic
      arphic-ukai arphic-uming
      unfonts-core
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Han Serif SC" ];
        sansSerif = [ "Source Han Sans SC" ];
        monospace = [ "Sarasa Mono SC" ];
        emoji = [ "Noto Emoji" ];
      };
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager = {
    sddm.enable = true;
    hiddenUsers = [ "oxa" ];
    defaultSession = "none+exwm";
  };

  services.xserver.windowManager.session = lib.singleton {
    name = "exwm";
    start = pkgs.writeShellScript "start-exwm" ''
      if [[ -f $HOME/.xsessions/exwm.xsession ]]
      then
        exec ${pkgs.runtimeShell} -c $HOME/.xsessions/exwm.xsession
      else
        exit 1
      fi
    '';
  };

  xdg.portal.enable = true;

  # Configure keymap in X11.
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl"; # included xkbOption "eurosign:5"
  services.xserver.xkbOptions = "caps:none"; # xkeyboard-config(7)

  services.autorandr.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = "load-module module-switch-on-connect";
}
