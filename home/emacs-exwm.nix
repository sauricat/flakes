{ inputs, pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGitNativeComp;
  emacsPackageWithPkgs =
    pkgs.emacsWithPackagesFromUsePackage {
      config =
        let
          readRecursively = dir:
            builtins.concatStringsSep "\n"
              (lib.mapAttrsToList (name: value: if value == "regular"
                                                then builtins.readFile (dir + "/${name}")
                                                else (if value == "directory"
                                                      then readRecursively (dir + "/${name}")
                                                      else [ ]))
                                  (builtins.readDir dir));
        in readRecursively ./emacs;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [ ];
      override = epkgs: epkgs // (
        let
          vterm-mouse-support = epkgs.melpaPackages.vterm.overrideAttrs (old: {
            patches = (old.patches or [ ])
                      ++ [ ./patch/vterm-mouse-support.patch ];
          });
        in {
          tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
            # Install all tree sitter grammars available from nixpkgs
            (grammars: builtins.filter lib.isDerivation (lib.attrValues (grammars // {
              tree-sitter-nix = grammars.tree-sitter-nix.overrideAttrs (old: {
                version = "fixed";
                src = inputs.tree-sitter-nix-oxa;
              });
            })));
          vterm = vterm-mouse-support;
          multi-vterm = epkgs.melpaPackages.multi-vterm.overrideAttrs (old: {
            buildInputs = [ emacsPackage pkgs.texinfo vterm-mouse-support ];
            propagatedBuildInputs = lib.singleton vterm-mouse-support;
            propagatedUserEnvPkgs = lib.singleton vterm-mouse-support;
          });
        });
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
