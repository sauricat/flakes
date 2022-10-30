# Author: Azalea (hykilpikonna)
# Source: github:hykilpikonna/nixpkgs
# License: MIT
{ lib
, stdenv
, python3Packages
, pciutils
, fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "HyFetch";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = pname;
    rev = version;
    sha256 = "sha256-5TzIhbyrhQmuxR/Vs3XpOj/8FnykmBiDj6sXfFZK0uM=";
  };

  propagatedBuildInputs = (with python3Packages; [
    typing-extensions
    setuptools
  ]) ++ [ pciutils ];

  postInstall = ''
    chmod +x $out/lib/python3.10/site-packages/hyfetch/scripts/neowofetch
    sed -e 's:lspci:${pciutils}/bin/lspci:g' $out/lib/python3.10/site-packages/hyfetch/scripts/neowofetch > $out/bin/neowofetch
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
    maintainers = with maintainers; [ sauricat ];
    mainProgram = "hyfetch";
  };
}
