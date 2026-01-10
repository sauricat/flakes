{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  emacsPackage = pkgs.emacs-pgtk;
  emacsPackageWithPkgs = pkgs.emacsWithPackagesFromUsePackage {
    config =
      let
        readRecursively =
          dir:
          builtins.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: value:
              if value == "regular" then
                builtins.readFile (dir + "/${name}")
              else
                (if value == "directory" then readRecursively (dir + "/${name}") else [ ])
            ) (builtins.readDir dir)
          );
      in
      readRecursively ./emacs;
    alwaysEnsure = true;
    package = emacsPackage;
    extraEmacsPackages = epkgs: [ ];
    override =
      epkgs:
      epkgs
      // ({
        toggle-one-window = epkgs.trivialBuild rec {
          pname = "toggle-one-window";
          ename = pname;
          version = "git";
          src = inputs.epkgs-toggle-one-window;
        };
        ligature = epkgs.trivialBuild rec {
          pname = "ligature";
          ename = pname;
          version = "git";
          src = inputs.epkgs-ligature;
        };
        typst-ts-mode = epkgs.trivialBuild rec {
          pname = "typst-ts-mode";
          ename = pname;
          version = "git";
          src = inputs.epkgs-typst-ts-mode;
        };
      });
  };
  lspPackages = with pkgs; [
    rust-analyzer
    nil # rnix-lsp
    pyright
    haskell-language-server
    solargraph
    yaml-language-server
    clang-tools
    elixir-ls
    tinymist
    # lua53Packages.digestif # Due to collision, 2023-08-29, with TeXLive
  ];
in
{
  home.packages =
    lib.singleton emacsPackageWithPkgs
    ++ lspPackages
    ++ [
      pkgs.zoxide
      pkgs.fzf
    ];
}
