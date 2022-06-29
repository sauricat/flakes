{ lib
, stdenv
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "PyQt6_sip";
  version = "13.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-bYej7lhy11EbdpV9aKMhCTUsrzt6QqAdnuIAMrNQ2Xk=";
  };

  propagatedBuildInputs = with python3Packages; [
    # typing-extensions
    # setuptools
    # numpy
  ];

  doCheck = false;
  pythonImportsCheck = ["PyQt6.sip"];

  meta = {
    description = "the sip extension module provides support for the PyQt6 package";
    homepage = "https://www.riverbankcomputing.com/software/sip/";
    license = lib.licenses.gpl3Only;
    platforms   = lib.platforms.mesaPlatforms;
    maintainers = with lib.maintainers; [ sauricat ];
  };
}
