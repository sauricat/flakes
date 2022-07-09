{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./mapping.nix
    ./emacs-exwm.nix
    ./wm-company.nix
    ./fish.nix
    ./firefox.nix
    ./compatibility.nix
    ./python.nix
  ];
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    # system:
    trash-cli bc
    man-pages tealdeer neofetch hyfetch kdeconnect

    # internet:
    tdesktop aria2 element-desktop
    vlc /*syncplay*/ obs-studio

    # work:
    libreoffice scribus gimp xournalpp
    okular pdftag ocrmypdf poppler_utils

    # devel:
    cabal-install ghc gcc gnumake yarn hugo binutils ruby_3_1
    xsel cachix zlib cmake pkg-config
    glibc gpgme asciidoc doxygen meson fakechroot
    bash-completion cling racket rustc cargo

    # non-oss:
    /*megasync*/

    # nur:
    # nur.repos.dukzcry.cockpit
  ];
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [ "*~" "\\#*\\#" ".\\#*" ]; # emacs
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
    pinentryFlavor = "curses";
  };

  home.stateVersion = "21.11";
}
