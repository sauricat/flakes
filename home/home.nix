{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  
}