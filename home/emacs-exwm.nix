{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGitNativeComp;
  emacsPackageWithPkgs =
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [ ];
      override = epkgs: epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars));
        vterm = epkgs.melpaPackages.vterm.overrideAttrs (old: {
          patches = (old.patches or [ ])
                    ++ [ ./emacs/vterm-mouse-support.patch ];
        });
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
rec {
  xsession = {
    enable = true;
    scriptPath = ".xsessions/exwm.xsession";
    profilePath = ".xsessions/exwm.xprofile";
    initExtra = "emacs --daemon";
    windowManager.command = "emacsclient -c -e '(init-exwm)'";
    importedVariables = lib.attrNames exwmSessionVariables;
  };

  # add the 2nd relevant xsession
  home.file.".xsessions/exwm-plasma.xsession" = {
    executable = true;
    text = builtins.replaceStrings
      [ xsession.windowManager.command ]
      [ "env KDEWM=${pkgs.writeShellScript "exwm-plasma-integration" "${emacsPackageWithPkgs}/bin/emacsclient -c -e '(exwm-init)'"} startplasma-x11" ]
      (config.home.file.${xsession.scriptPath}.text);
  };

  home.sessionVariables = exwmSessionVariables // {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  home.packages = lib.singleton emacsPackageWithPkgs
                  ++ lspPackages
                  ++ [ pkgs.zoxide pkgs.fzf ];
}
