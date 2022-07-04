{ lib
, stdenv
, fetchsvn
, SDL
, SDL_image
, SDL_net
, SDL_ttf
, SDL_gfx
, libpng12
, bison
, flex
, dos2unix
}:

stdenv.mkDerivation {
  pname = "pebl";
  version = "2.1-svn-1499";
  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/pebl/code-0/trunk";
    rev = "1499";
    sha256 = "sha256-RUAxQmUr6EcMxN6jXUtGuAY/CsjVx4awbz0+m6mNous=";
  };
  patches = [ ./patch.patch ];
  nativeBuildInputs = [ dos2unix ];
  buildInputs = [ SDL SDL_image SDL_net SDL_ttf SDL_gfx bison flex libpng12 ];
  buildFlags = [ "USE_DEBUG=" ];
  installFlags = [ "PREFIX=${placeholder "out"}/" ];

  meta = {
    description = "Psychology Experiment Building Language";
    license = lib.licenses.gpl2;
    mainProgram = "pebl";
    maintainers = with lib.maintainers; [ sauricat ];
    platforms = [ "x86_64-linux" ];
  };
}
