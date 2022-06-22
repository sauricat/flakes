# Author: Azalea (hykilpikonna)
# Source: github:hykilpikonna/nixpkgs
# License: MIT
{ lib
, stdenv
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "HyFetch";
  version = "git-d11796";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = pname;
    rev = "d11796ef023d8bbe916527efeb903c81d9ae1fbd";
    hash = "sha256-quagGaY5ZVhTGFaQKE09u+KuCFsBKMyhHWvWFfYVfFo=";
  };

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    setuptools
    numpy
  ];

  doCheck = false;

  meta = with lib; {
    description = "neofetch with pride flags <3";
    longDescription = ''
        HyFetch is a command-line system information tool fork of neofetch.
        HyFetch displays information about your system next to your OS logo
        in ASCII representation. The ASCII representation is then colored in
        the pattern of the pride flag of your choice. The main purpose of
        HyFetch is to be used in screenshots to show other users what
        operating system or distribution you are running, what theme or
        icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = licenses.mit;
    maintainers = with maintainers; [ hykilpikonna ];
    mainProgram = "hyfetch";
  };
}
