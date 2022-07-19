{ pkgs, ... }:
let
  pythonWithPkgs = pkgs.python3.withPackages
    (ppkgs: with ppkgs; [
      epc
    ]);
in
{
  home.packages = with pkgs; [
    pythonWithPkgs
    cabal-install ghc gcc gnumake yarn hugo binutils ruby_3_1
    xsel xclip
    bash-completion cling racket rustc cargo elixir
  ];

  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
      diff.renameLimit = 10000;
    };
    ignores = [ "*~" "\\#*\\#" ".\\#*" ]; # emacs
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
