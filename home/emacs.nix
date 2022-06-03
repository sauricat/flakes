{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsUnstable;
  emacsPackageWithPkgs = 
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars)); };
    };
  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.runtimeShell}
    if [ -z "$1" ]; then
      exec ${emacsPackageWithPkgs}/bin/emacsclient --create-frame --alternate-editor ${emacsPackageWithPkgs}/bin/emacs
    else
      exec ${emacsPackageWithPkgs}/bin/emacsclient --alternate-editor ${emacsPackageWithPkgs}/bin/emacs "$@"
    fi
  '';
in
{
  # For emacs client cannot recognize epkgs, temporarily disable these options.
  #
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = pkgs.emacsUnstable;
  # };

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      Documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
      X-RestartIfChanged = false;
    };
    Service = {
      Restart = "on-failure";
      ExecStart = "${emacsPackageWithPkgs}/bin/emacs -l cl-loaddefs -l nix-generated-autoload --fg-daemon";
      SuccessExitStatus = 15;
      Type = "notify";
    };
  };
  systemd.user.sessionVariables."EDITOR" = "${editorScript}/bin/emacseditor";

  home.packages = [ emacsPackageWithPkgs ];
  
  home.file.".emacs.d/init.el".source = ./emacs/init.el;
}
