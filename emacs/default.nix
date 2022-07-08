{ pkgs, config, lib, ... }:
let
  emacsPackage = pkgs.emacsGit;
  emacsPackageWithPkgs = 
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [ ];
      override = epkgs : epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins
          # Install all tree sitter grammars available from nixpkgs
          (grammars: builtins.filter lib.isDerivation (lib.attrValues grammars));
      };
    };
  lsp-packages = with pkgs; [
    lsp-bridge
    rust-analyzer
    rnix-lsp
    pyright
    haskell-language-server
    solargraph
    yaml-language-server
  ];
  exwm-independent-packages = with pkgs; [
    maim xclip # for printing screen and copying it to clipboard
    gtk3 # for gtk-launch
    kscreenlocker
    alsa-utils brightnessctl upower tlp playerctl # for epkgs.desktop-environment
    networkmanagerapplet
  ];
  callExwm =
    pkgs.writeShellScript "callExwm" ''
      ${emacsPackageWithPkgs}/bin/emacs --daemon
      ${emacsPackageWithPkgs}/bin/emacsclient -c -e "(exwm-init)"
    '';
  callExwmIndependently =
    pkgs.writeShellScript "callExwmIndependently" ''
      ${emacsPackageWithPkgs}/bin/emacs --daemon
      ${emacsPackageWithPkgs}/bin/emacsclient -c -e "(init-exwm)"
    '';
in
{
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true;
  #   package = emacsPackageWithPkgs;
  # };

  environment.sessionVariables.EDITOR = "${emacsPackageWithPkgs}/bin/emacsclient";
  environment.systemPackages = [ emacsPackageWithPkgs ]
                               ++ lsp-packages
                               ++ [ pkgs.zoxide pkgs.fzf ]
                               ++ exwm-independent-packages;

  # EXWM
  services.xserver.windowManager.session = [
    { name = "exwm-plasma";
      start = ''
        env KDEWM=${callExwm} ${pkgs.plasma-workspace}/bin/startplasma-x11
      ''; }
    { name = "exwm";
      start = ''
        ${callExwmIndependently}
      ''; }
  ];
  services.xserver.displayManager.defaultSession = "none+exwm-plasma";
}
