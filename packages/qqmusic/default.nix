# UNDER CONSTRUCTION 

{ stdenv, lib, 
  fetchurl,
  dpkg, steam-run, 
  gtk2, gtk3, libnotify, nss, xorg, xdg-utils, at-spi2-core, libuuid, libappindicator, libsecret, qt5 }:

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
    gtk2 gtk3 
    libnotify
    nss
    #xorg.libXScrnSaver
    #xorg.libXtst
    xdg-utils
    at-spi2-core
    libuuid
    libappindicator
    libsecret

    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg

    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    # As to build and run
    dpkg
    steam-run
  ];

  dontWrapQtApps = true;
  
  installPhase = ''
    mkdir -p $out
    cp -R ./opt $out/opt
    cp -R ./usr $out/usr
    mkdir -p $out/bin
    echo -e ${steam-run}/bin/steam-run $out/opt/qqmusic/qqmusic > $out/bin/qqmusic
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

