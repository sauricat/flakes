{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./mapping.nix
    ./emacs-exwm.nix
    ./wm-company.nix
    ./fish.nix
    ./firefox.nix
    ./compatibility.nix
    ./devel.nix
  ];
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    # system:
    trash-cli bc cachix
    man-pages tealdeer neofetch hyfetch kdeconnect

    # internet:
    tdesktop aria2 element-desktop
    vlc syncplay obs-studio

    # work:
    libreoffice scribus gimp xournalpp
    okular pdftag ocrmypdf poppler_utils

    # non-oss:
    megasync

    # nur:
    # nur.repos.dukzcry.cockpit
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
    pinentryFlavor = "curses";
  };

  home.stateVersion = "21.11";
}
