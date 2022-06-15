{ inputs, config, pkgs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ./rime.nix
    ./emacs.nix
    ./fish.nix
    ./firefox.nix
    ./compatibility.nix
  ];
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = (with pkgs; [
    # system:
    trash-cli bc
    man-pages tealdeer neofetch kdeconnect

    # internet:
    tdesktop aria2
    vlc syncplay obs-studio
    
    # work:
    libreoffice scribus gimp onlyoffice-bin xournalpp
    okular qpdf pdfstudio pdftag ocrmypdf

    # devel:
    cabal-install ghc gcc gnumake yarn hugo binutils ruby_3_1
    xsel cachix zlib cmake pkg-config 
    glibc gpgme asciidoc doxygen meson fakechroot python3
    bash-completion cling racket rustc cargo


    # non-oss:
    megasync vscode

    # nur:
    nur.repos.dukzcry.cockpit
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
    ignores = [ "*~" "\\#*\\#" ".\\#*" ]; # emacs
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/clash-configuration/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt"; 
  };

  home.stateVersion = "21.11";
}
