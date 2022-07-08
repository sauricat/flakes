{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGitNativeComp;
  emacsPackageWithPkgs =
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [ ];
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars));
      };
    };
  lspPackages = with pkgs; [
    rust-analyzer
    rnix-lsp
    pyright
    haskell-language-server
    solargraph
    yaml-language-server
    clang-tools
  ];
  exwmSessionVariables = {
    EDITOR = "emacsclient";
    XMODIFIERS = "@im=ibus";
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    CLUTTER_IM_MODULE = "ibus";
  };
in
{
  xsession = {
    enable = true;
    initExtra = "emacs --daemon";
    windowManager.command = "emacsclient -c -e '(init-exwm)'"; # ''
#       echo -e "Launch EXWM with KDE Plasma? (Y/n)"
#       read -p ">> " flag
#       if [[ "$flag" != "n" && "$flag" != "N" ]]
#       then
#         env KDEWM="emacsclient -c -e '(exwm-init)'" startplasma-x11
#       else
#         emacsclient -c -e '(init-exwm)'
#       fi
#     '';
    importedVariables = lib.attrNames exwmSessionVariables;
  };
  home.sessionVariables = exwmSessionVariables // {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  home.packages = lib.singleton emacsPackageWithPkgs
                  ++ lspPackages
                  ++ [ pkgs.zoxide pkgs.fzf ];
}
