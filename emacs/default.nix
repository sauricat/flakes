{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsUnstable;
  emacsPackageWithPkgs = 
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars)); };
    };
  # editorScript = pkgs.writeScriptBin "emacseditor" ''
  #   #!${pkgs.runtimeShell}
  #   if [[ -z "$1" ]]; then
  #     exec ${emacsPackageWithPkgs}/bin/emacsclient --create-frame --alternate-editor ${emacsPackageWithPkgs}/bin/emacs
  #   else
  #     exec ${emacsPackageWithPkgs}/bin/emacsclient --alternate-editor ${emacsPackageWithPkgs}/bin/emacs "$@"
  #   fi
  # '';
in
{
  # For emacs client cannot recognize epkgs, temporarily disable these options.
  #
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = emacsPackageWithPkgs;
  # };

  systemd.user.services.emacsServerForExwm = {
    wantedBy = [ "graphical-session.target" ];
    description = "Emacs text editor";
    documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
    script = "${emacsPackageWithPkgs}/bin/emacs -l cl-loaddefs -l nix-generated-autoload --daemon";
    unitConfig = {
      X-RestartIfChanged = false;
    };
    serviceConfig = {
      Restart = "on-failure";
      SuccessExitStatus = 15;
      Type = "notify";
    };
  };
  environment.sessionVariables.EDITOR = "${emacsPackageWithPkgs}/bin/emacsclient";
  environment.systemPackages = [
    emacsPackageWithPkgs
    pkgs.rust-analyzer
    pkgs.rnix-lsp
    pkgs.zoxide
    pkgs.fzf
  ];


  # EXWM
  services.xserver.windowManager.session = lib.singleton {
    name = "exwm-plasma";
    start =
      ''
        env KDEWM=${pkgs.writeShellScript "callEmacsClient"
          ''
            ${pkgs.emacsUnstable}/bin/emacs -l cl-loaddefs -l nix-generated-autoload --daemon
            ${pkgs.emacsUnstable}/bin/emacsclient -c
          ''
                   } ${pkgs.plasma-workspace}/bin/startplasma-x11
      '';
  };
}
