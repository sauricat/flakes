{ pkgs, config, lib, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      nix-mode
      magit
      ivy
      vterm
      winum
    ];
    extraConfig = ''
      (require 'winum)
      (winum-mode)
      (global-set-key (kbd "C-z") 'undo)
    '';
  };
  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';
}
