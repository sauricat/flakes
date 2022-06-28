# Usage:
# make a symlink from ${lsp-bridge} to your ~/.emacs.d

{ stdenv
, lib
, fetchFromGitHub
, poetry2nix
}:

let
  pname = "lsp-bridge";
  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = pname;
    rev = "a79f2dc411633aa3e06d3890e1d9e2b5011f7b26";
    hash = "sha256-KURgksPmyYnOd7tZxHSGf6o4IzjN9PesSlm3lzhN12A=";
  };
  pythonEnv = (poetry2nix.mkPoetryEnv {
    projectDir = src.outPath;
    pyproject = "${./pyproject.toml}";
    poetrylock = "${./poetry.lock}";
  });
in stdenv.mkDerivation {
  inherit pname src;
  version = "git";

  buildInputs = [ ];
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    sed '1c #!${pythonEnv}/bin/python3' $src/lsp_bridge.py > $out/lsp_bridge.py
    sed '266c (defcustom lsp-bridge-python-command "${pythonEnv}/bin/python3"' $src/lsp-bridge.el > $out/lsp-bridge.el
    cp -rn $src/* $out
  '';
  meta = {
    description = "Emacs LSP Bridge";
    longDescription = ''
      tba
    '';
    homepage = "https://github.com/manateelazycat/lsp-bridge/";
    license = lib.licenses.free;
    maintainers = [ ];
    mainProgram = "lsp-bridge";
  };
}
