{ pkgs, ... }:
let
  pythonWithPkgs = pkgs.python3.withPackages (
    ppkgs: with ppkgs; [
      epc
    ]
  );
in
{
  home.packages = with pkgs; [
    pythonWithPkgs
    cabal-install
    ghc
    gcc
    gnumake
    yarn
    hugo
    binutils
    ruby_3_1
    xsel
    xclip
    bash-completion
    cling
    racket
    rustc
    cargo
    elixir
    github-cli
  ];

  programs.git = {
    enable = true;
    userEmail = "saurica@kazv.moe";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
      diff.renameLimit = 10000;
      pull.ff = "only";
    };
    ignores = [
      "*~"
      "\\#*\\#"
      ".\\#*"
    ]; # emacs
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
