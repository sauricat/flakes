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
    tdesktop aria2 element-desktop thunderbird
    vlc syncplay obs-studio hydroxide

    # work:
    libreoffice scribus gimp xournalpp krita
    okular pdftag ocrmypdf poppler_utils

    # non-oss:
    megasync zoom-us

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
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (ps: [ ps.pass-otp ]);
  };
  systemd.user.services.hydroxide = {
    Unit.Description = "ProtonMail Bridge";
    Service = {
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
      Restart = "on-failure";
      RestartSec = 10;
      Slice = "background.slice";
    };
    Install.WantedBy = [ "graphical-session.target" ];
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
