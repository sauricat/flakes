{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGit;
  emacsPackageWithPkgs = 
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: with epkgs; [
        vterm
      ];
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars));
        vterm-with-mouse-support = epkgs.vterm.overrideAttrs (oldAttrs: rec {
          commit = "a1af04d1db8a677c727776b7f15e3a1529ea8a50"; # HEAD of branch "tmux_mouse_scroll_support"
          src = pkgs.fetchFromGitHub {
            owner = "akermu";
            repo = "emacs-libvterm";
            rev = commit;
            sha256 = "sha256-m0Pxko/F6hYU0sIpYl1ImMwejcWu2kwTphqPuPUrIek=";
          };
        });
      };
    };
in
{
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = emacsPackageWithPkgs;
  # };

  environment.sessionVariables.EDITOR = "${emacsPackageWithPkgs}/bin/emacsclient";
  environment.systemPackages = [ emacsPackageWithPkgs ] ++ (with pkgs; [
    rust-analyzer
    rnix-lsp
    pyright
    haskell-language-server
    solargraph
    yaml-language-server
    zoxide
    fzf
    lsp-bridge
  ]);

  # EXWM
  services.xserver.windowManager.session = lib.singleton {
    name = "exwm-plasma";
    start =
      ''
        env KDEWM=${pkgs.writeShellScript "callEmacsClient"
          ''
            ${emacsPackageWithPkgs}/bin/emacs --daemon
            ${emacsPackageWithPkgs}/bin/emacsclient -c -e "(exwm-init)"
          ''
                   } ${pkgs.plasma-workspace}/bin/startplasma-x11
      '';
  };
  services.xserver.displayManager.defaultSession = "none+exwm-plasma";
}
