
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
      nix-mode
      magit
      ivy
      vterm multi-vterm
      winum
      paredit
      doom-themes
      neotree
    ];
  };
  home.file = lib.attrsets.mapAttrs' (name: value: 
    lib.attrsets.nameValuePair 
      (".emacs.d/${value}") 
      ({ source = config.lib.file.mkOutOfStoreSymlink ./emacs/${value}; })){
           init = "init.el";
         };
}
