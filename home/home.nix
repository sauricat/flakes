{ host, config, pkgs, ... }:
{
  imports = [
    ./mapping.nix
    ./emacs-pgtk.nix
    ./fish.nix
    ./firefox.nix
    ./compatibility.nix
    ./devel.nix
  ] ++ (
    if host == "wlsn"
    then [
      # ./tex.nix
    ]
    else [
      ./virtual-keyboard.nix
    ]
  );
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    # system:
    trash-cli bc cachix
    man-pages tealdeer

    # internet:
    tdesktop aria2 element-desktop thunderbird
    vlc /*syncplay*/ obs-studio

    # work:
    libreoffice scribus gimp xournalpp krita calibre
    okular pdftag ocrmypdf poppler_utils
    zotero pandoc

    # non-oss:
    megasync zoom-us obsidian

    # nur:
    nur.repos.xyenon.kazv
  ];
  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    escapeTime = 1;
    terminal = "tmux-256color";
    extraConfig = "set -g mouse on";
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/clash-configuration/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    # pinentryFlavor = "curses";
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (ps: [ ps.pass-otp ]);
  };

  home.sessionVariables.MOZ_USE_XINPUT2 = "1";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.kde.okular.desktop";
      "image/*" = "org.kde.gwenview.desktop";
      "video/*" = "vlc.desktop";
      "text/html" = "firefox.desktop";
      "text/plain" = "emacsclient.desktop";
    };
  };
  home.stateVersion = "21.11";
}
