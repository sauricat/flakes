{ config, pkgs, lib, ... }:

{
  home.username = "shu";
  home.homeDirectory = "/home/shu";

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  home.stateVersion = "21.11";
  
}