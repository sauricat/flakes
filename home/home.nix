{ host, config, pkgs, ... }:
{
  imports = [
    ./mapping.nix
    ./emacs-pgtk.nix
    ./fish.nix
    ./firefox.nix
    ./compatibility.nix
    ./devel.nix
    ./tex.nix
  ];
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    # system:
    trash-cli bc cachix
    man-pages tealdeer

    # internet:
    tdesktop aria2 element-desktop thunderbird
    vlc # kazv
    obs-studio

    # work:
    libreoffice scribus gimp xournalpp krita calibre
    tesseract poppler_utils
    zotero pandoc

    typst typstfmt typst-lsp typst-live

    # non-oss:
    megasync zoom-us
    # nur:
    # nur.repos.xyenon.kazv
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

  home.stateVersion = "21.11";
}
