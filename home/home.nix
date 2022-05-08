{ config, pkgs, lib, ... }:

{
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    ark filelight vlc bc
    firefox tdesktop
    man-pages tealdeer
    okular libreoffice scribusUnstable gimp
    vscodium cabal-install ghc yarn hugo binutils
  ];

  # home.file = 
  # {
  #   ".config/ibus/rime/chaizi.schema.yaml".source = config.lib.file.mkOutOfStoreSymlink ./config/ibus-rime/chaizi.schema.yaml;
  #   ".config/ibus/rime/chaizi.dict.yaml".source = config.lib.file.mkOutOfStoreSymlink ./config/ibus-rime/chaizi.dict.yaml;
  # }; 

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  programs.fish = {
    enable = true;
    shellAbbrs = {
      l = "ls -ahl";
      g = "git";
      b = "bc -l";
      t = "tar";
    };
  };

  programs.emacs = {
    enable = true;

  };
  home.stateVersion = "21.11";
  
}