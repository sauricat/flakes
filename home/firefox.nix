{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles."main.profile" = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.startup.page" = 3; # Always resume the previous browser session.
        "browser.quitShortcut.disabled" = true;

        "font.cjk_pref_fallback_order" = "ja,zh-cn,zh-hk,zh-tw,ko";

        "font.name.monospace.zh-CN" = "Sarasa Mono SC";
        "font.name.serif.zh-CN" = "Source Han Serif SC";
        "font.name.sans-serif.zh-CN" = "Source Han Sans SC";
        "font.name.cursive.zh-CN" = "AR PL UKai CN";

        "font.name.monospace.zh-HK" = "Sarasa Mono HC";
        "font.name.serif.zh-HK" = "Source Han Serif HC";
        "font.name.sans-serif.zh-HK" = "Source Han Sans HC";
        "font.name.cursive.zh-HK" = "AR PL UKai HK";

        "font.name.monospace.zh-TW" = "Sarasa Mono TC";
        "font.name.serif.zh-TW" = "Source Han Serif TC";
        "font.name.sans-serif.zh-TW" = "Source Han Sans TC";
        "font.name.cursive.zh-TW" = "AR PL UKai TW";

        "font.name.monospace.ja" = "Sarasa Mono J";
        "font.name.serif.ja" = "Source Han Serif";
        "font.name.sans-serif.ja" = "Source Han Sans";
        # "font.name.cursive.ja" = "";

        "font.name.monospace.ko" = "Sarasa Mono K";
        "font.name.serif.ko" = "Source Han Serif K";
        "font.name.sans-serif.ko" = "Source Han Sans K";
        "font.name.cursive.ko" = "UnGungseo";
      };
    };
  };
}
