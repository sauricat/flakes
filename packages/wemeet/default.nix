# Author: NickCao
# Source: gitlab:NickCao/flakes pkgs/wemeet
{ qt5, fetchurl, dpkg, autoPatchelfHook, xorg, libbsd }:
qt5.mkDerivation {
  pname = "wemeet";
  version = "2.8.0.3";
  src = fetchurl {
    url = "https://updatecdn.meeting.qq.com/cos/3cdd365cd90f221fb345ab73c4746e1f/TencentMeeting_0300000000_2.8.0.3_x86_64_default.publish.deb";
    sha256 = "sha256-76Bm4PaIo7APwYBKWXp14up+PXS+Eo7NLcWM6Q2nhZ8=";
  };
  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXdamage
    qt5.qtwebkit
    qt5.qtx11extras
    libbsd
  ];
  autoPatchelfIgnoreMissingDeps = [
    "libcudart.so.9.0"
    "libcudnn.so.7"
    "libnvinfer.so.5"
    "libnvinfer_plugin.so.5"
  ];
  dontUnpack = true;
  installPhase = ''
    dpkg-deb -x $src .
    mkdir $out
    mv opt/wemeet/bin $out/bin
    mkdir $out/lib
    mv opt/wemeet/lib/{libwemeet*,libxcast.so,libxnn*,libtquic.so} $out/lib
    mkdir $out/share
    mv opt/wemeet/icons $out/share
  '';
  meta = {
    mainProgram = "wemeetapp";
    platforms = [ "x86_64-linux" ];
  };
}
