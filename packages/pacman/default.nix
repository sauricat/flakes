{ stdenv, lib, fetchurl, pkg-config, perl, libarchive, openssl, zlib, bzip2, xz, 
  bash, bash-completion, curl, glibc, gpgme, asciidoc, doxygen, meson, 
  fakechroot, python3, runtimeShell, coreutils }:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.1";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0cgp7c6v14rykpr22mdicag32472bc10n7491qk9x93awmb19dhd";
  };

  enableParallelBuilding = true;

  configureFlags = [
    # trying to build docs fails with a2x errors, unable to fix through asciidoc
    "--disable-doc"

    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-scriptlet-shell=${runtimeShell}"
  ];

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ perl libarchive openssl zlib bzip2 xz 
    bash bash-completion curl glibc gpgme asciidoc doxygen meson fakechroot python3 coreutils ];


  installPhase = ''
    start="$(pwd)"
    ln -sf ${coreutils}/bin/true /bin/true
    mkdir -p $out
    cd $start
    cp -R ./etc $out/etc
    cp -R ./doc $out/doc
    pkg-config --libs ${libarchive} ${bash-completion}
    meson $out/bin
    
    unlink /bin/true
  '';

  postFixup = ''
    substituteInPlace $out/bin/repo-add \
      --replace bsdtar "${libarchive}/bin/bsdtar"
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://www.archlinux.org/pacman/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret sauricat ];
  };
}