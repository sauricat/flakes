{ inputs, config, pkgs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ./rime.nix
    ./emacs.nix
    ./fish.nix
  ];
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = (with pkgs; [
    # system:
    htop procs trash-cli filelight ark bc
    man-pages tealdeer neofetch kdeconnect

    # internet:
    firefox tdesktop aria2
    vlc syncplay obs-studio
    
    # work:
    libreoffice scribus gimp onlyoffice-bin kate xournalpp
    okular qpdf pdfstudio pdftag ocrmypdf

    # devel:
    cabal-install ghc gcc gnumake yarn hugo binutils ruby_3_1
    xsel cachix zlib cmake pkg-config 
    glibc gpgme asciidoc doxygen meson fakechroot python3
    bash-completion cling racket

    # compatibility:
    wine winetricks samba
    steam-run #dpkg apt rpm

    # non-oss:
    megasync vscode

    # nur:
    nur.repos.dukzcry.cockpit

    # nixos-cn:
    nixos-cn.wine-wechat
    nixos-cn.netease-cloud-music

    # my own overlay:
    qqmusic #pacman
  ]) ++ (with inputs.nixos-guix.packages.${system}; [
    nixos-guix
  ]) ++ (with inputs.nixpkgs-master.legacyPackages.${system};[
    #tdesktop
  ]);
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  home.stateVersion = "21.11";
  
}
