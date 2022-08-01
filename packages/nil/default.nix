{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "git-bc9dc1";
  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = "bc9dc1546f2731c4a8b2b33187cb3f8e323e8e70";
    sha256 = "sha256-TJQ7kaMpUxMEg7j4wkox6yMFv6la8les1To7znSDj/A=";
  };
  cargoSha256 = "sha256-OQRUvET0iEnKHZqhDdND47q/jXfY+Qi32fSpsBCLStw=";
  buildAndTestSubdir = "lsp";
  meta = {
    description = "Language Server for Nix Expression Language";
    homepage = "https://github.com/oxalica/nil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sauricat ];
  };
}
