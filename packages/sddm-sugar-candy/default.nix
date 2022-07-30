# reference: github:Shados/nixos-config
#            rev 0db53dbaa1fce37ca56c091bfdaf8f189e5c8956
#            /apps/sddm/sddm-sugar-dark.nix
{ stdenv, lib, fetchgit
, qt5
, crudini
, configOverrides ? null
}:
let
  configOverridden = configOverrides != null;
in
stdenv.mkDerivation rec {
  pname = "sddm-sugar-candy";
  version = "git";

  src = fetchgit {
    url = "https://framagit.org/MarianArlt/sddm-sugar-candy.git";
    rev = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
    sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
  };

  nativeBuildInputs = lib.optional configOverridden crudini;
  propagatedUserEnvPkgs = [
    qt5.qtgraphicaleffects
  ];

  installPhase = ''
    mkdir -p "$out/share/sddm/themes/"
    cp -r "$src" "$out/share/sddm/themes/sugar-candy"
  '' + lib.optionalString configOverridden ''
    chmod -R u+w "$out/share/sddm/themes/"
    crudini --merge "$out/share/sddm/themes/"*/theme.conf < "${configOverrides}"
  '';

  meta = with lib; {
    description = "Sweeten the login experience for your users, your family and yourself.";
    homepage    = "https://framagit.org/MarianArlt/sddm-sugar-candy";
    maintainers = [ maintainers.sauricat ];
    license     = licenses.gpl3;
  };
}
