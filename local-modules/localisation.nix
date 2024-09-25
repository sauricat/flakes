# Named localisation, but actually services stuffs, including X11 server.
{ pkgs, lib, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "ja_JP.UTF-8";
      LC_CTYPE = "ja_JP.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        (fcitx5-rime.override { rimeDataPkgs = [ rime-data ]; })
        fcitx5-anthy
        fcitx5-configtool
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
  # nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Some defaults, override "basics.nix"
  # programs.gnupg.agent.pinentryFlavor = lib.mkOverride 900 "qt";
  programs.command-not-found.enable   = lib.mkOverride 900 true;
  services.flatpak.enable             = lib.mkOverride 900 true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols

      # CJKV
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      hanazono
      source-han-sans source-han-serif source-han-mono
      source-han-sans-japanese source-han-serif-japanese source-han-code-jp
      wqy_microhei wqy_zenhei
      sarasa-gothic
      arphic-ukai arphic-uming
      unfonts-core

      twemoji-color-font
      font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        serif = [ "Noto Serif" "源ノ明朝" "Noto Emoji" ];
        sansSerif = serif;
        # sansSerif = [ "Noto Sans" "源ノ角ゴシック" "Noto Emoji" ];
        monospace = [ "更紗等幅ゴシック J" ];
        emoji = [ "Noto Emoji" ];
      };

      # localConf = ''
      #   <?xml version="1.0" encoding="UTF-8"?>
      #   <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      #   <fontconfig>
      #     <!-- Use language-specific font variants. -->
      #     ${lib.concatMapStringsSep "\n" ({ lang, variant }:
      #       let
      #         replace = from: to: ''
      #           <match target="pattern">
      #             <test name="lang" compare="contains">
      #               <string>${lang}</string>
      #             </test>
      #             <test name="family">
      #               <string>${from}</string>
      #             </test>
      #             <edit name="family" binding="strong" mode="prepend_first">
      #               <string>${to}</string>
      #             </edit>
      #           </match>
      #         '';
      #       in
      #       replace "sans-serif" "Noto Sans CJK ${variant}" +
      #       replace "serif" "Noto Serif CJK ${variant}"
      #     ) [
      #       { lang = "zh";    variant = "SC"; }
      #       { lang = "zh-TW"; variant = "TC"; }
      #       { lang = "zh-HK"; variant = "HK"; }
      #       { lang = "ja";    variant = "JP"; }
      #       { lang = "ko";    variant = "KR";  }
      #     ]}
      #   </fontconfig>
      # '';
    };
  };

  xdg.portal.enable = true;

  # services.autorandr.enable = true;

  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
}
