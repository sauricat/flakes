{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGit;
  emacsPackageWithPkgs = 
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [
      ];
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars)); };
    };
in
{
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = emacsPackageWithPkgs;
  # };

  environment.sessionVariables.EDITOR = "${emacsPackageWithPkgs}/bin/emacsclient";
  environment.systemPackages = [
    emacsPackageWithPkgs
    pkgs.rust-analyzer
    pkgs.rnix-lsp
    pkgs.zoxide
    pkgs.fzf
    pkgs.lsp-bridge
  ];

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
