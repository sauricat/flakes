# UNDER CONSTRUCTION 

{ stdenv, lib, 
  fetchurl,
  dpkg, steam-run, 
  gtk3, libnotify, nss, xorg, xdg-utils, at-spi2-core, libuuid, libappindicator, libsecret }:

stdenv.mkDerivation rec {
  pname = "qqmusic";
  version = "1.1.4";
  src = fetchurl {
    url =
      "https://dldir1.qq.com/music/clntupate/linux/deb/qqmusic_${version}_amd64.deb";
    sha256 = "1kfqqzg3dsz8gbznl6qxzksdhavqxf4zfl8chp00ja4ayzsvj9q0";
    # curlOpts = "-A 'Mozilla/5.0'";
  };
  unpackCmd = "${dpkg}/bin/dpkg -x $src .";
  sourceRoot = ".";

  # nativeBuildInputs = TODO: what is this?
  buildInputs = [ # As written in the deb file
    gtk3 
    libnotify
    nss
    xorg.libXScrnSaver
    xorg.libXtst
    xdg-utils
    at-spi2-core
    libuuid
    libappindicator
    libsecret
    
    # As to build and run
    dpkg
    steam-run
  ];

  installPhase = ''
    mkdir -p $out
    cp -r ./opt $out/bin
    cp -r ./usr $out/usr
    # echo -e ${steam-run}/bin/steam-run $out/bin/qqmusic/qqmusic > $out/bin/qqmusic-sr
    chmod +x $out/bin/qqmusic
  '';

  # postFixup = TODO: what is this?

  meta = {
    description = "Client for QQ Music service";
    homepage = "https://y.qq.com";
    platforms = [ "x86_64-linux" ];
    maintainers = [ "sauricat" ];
    license = lib.licenses.unfree;
  };
}

