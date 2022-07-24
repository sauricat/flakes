{ stdenv
, lib
, fetchFromGitHub
, runtimeShell
, networkmanager
, rofi
, dunst
, qrencode }:
let
  runtimeInputs = [
    networkmanager
    rofi
    dunst
    qrencode
  ];
in stdenv.mkDerivation rec {
  pname = "rofi-network-manager";
  version = "git";
  src = fetchFromGitHub {
    owner = "sauricat";
    repo = pname;
    rev = "7b3ea9e03f8b3f0b45c3f3f9a99a91bd6f0f0da5";
    sha256 = "sha256-c+o4MQE7IYEnQcp67qw4xyFmXD1T9glBu51pWoWU/oo=";
  };
  buildInputs = runtimeInputs;
  installPhase = ''
    mkdir -p $out
    cp -r . $out
    cat > $out/bin/rofi-network-manager <<EOF
    #!${runtimeShell}
    set -o errexit
    set -o nounset
    set -o pipefail
    export PATH="${lib.makeBinPath runtimeInputs}:\$PATH"
    EOF

    cat ./bin/rofi-network-manager >> $out/bin/rofi-network-manager
    chmod +x $out/bin/rofi-network-manager
  '';
  meta = {
    description = "Use rofi as NetworkManager GUI frontend";
    license = lib.licenses.mit;
  };
}
