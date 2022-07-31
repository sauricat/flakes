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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = pname;
    rev = "42d6aa490afa171cc92224b0f0b963e56e2afd94";
    sha256 = "sha256-ihYclh8iI3KDTV8MFN7VZq+RUQ+0yEZQ0jAYmmExwHg=";
  };

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    setuptools
  ];

  postInstall = ''
    chmod +x $out/lib/python3.10/site-packages/hyfetch/scripts/neowofetch
  '';
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
