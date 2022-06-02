
{ pkgs, config, lib, ... }:
{
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      use-package
      nix-mode markdown-mode yaml-mode fish-mode
      magit
      ivy counsel swiper
      vterm multi-vterm
      winum
      paredit
      doom-themes
      neotree
      racket-mode
      dired-single
      pdf-tools
      highlight-parentheses
      flycheck
    ];
  };
  home.file = lib.attrsets.mapAttrs' (name: value: 
    lib.attrsets.nameValuePair 
      (".emacs.d/${value}") 
      ({ source = config.lib.file.mkOutOfStoreSymlink ./emacs/${value}; })){
           init = "init.el";
         };
}
