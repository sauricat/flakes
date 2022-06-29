{ lib
, stdenv
, python3Packages
, pkgs # debug
}:

python3Packages.buildPythonPackage rec {
  pname = "PyQt6";
  version = "6.3.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-jMbiHbr3BH0fyJfjlszZcQoS8u+XZWPa1l8GAX0sl1c=";
  };
  format = "pyproject";

  propagatedBuildInputs = with python3Packages; [
    pkgs.pyqt6_sip #debug
    pyqt-builder
  ];

  # doCheck = false;

  meta = {
    description = "a comprehensive set of Python bindings for Qt v6";
    longDescription = ''
        TBA
    '';
    homepage = "https://www.riverbankcomputing.com/software/pyqt/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sauricat ];
  };
}
