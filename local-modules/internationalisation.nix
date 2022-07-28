{ ... }:
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
}
