{ stdenv, lib, fetchFromGitHub, luajit }:
stdenv.mkDerivation rec {
  pname = "librime-lua";
  version = "20221007";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = pname;
    rev = "0d8917b89dbab2c127f1887d2794e12b6383c3ab";
    sha256 = "sha256-sCbE9kYS0pyWdLsOJ9L3fBu3+nDmSw/ere9K7s9g9g4=";
  };

  buildInputs = [ luajit ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
    chmod +w $out/src/types_ext.cc
    sed '127c return {}; auto t = (an<T>) c->Create(Ticket());' $src/src/types_ext.cc > $out/src/types_ext.cc
  '';

  meta = with lib; {
    description = "Lua plugin of librime.";
    homepage    = "https://github.com/hchunhui/librime-lua";
    maintainers = [ maintainers.sauricat ];
    license     = licenses.bsd3;
  };
}
