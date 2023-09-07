{ pkgs, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "ja_JP.UTF-8";
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
}
