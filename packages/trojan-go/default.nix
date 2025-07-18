{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "trojan-go";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "p4gefau1t";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZzIEKyLhHwYEWBfi6fHlCbkEImetEaRewbsHQEduB5Y=";
  };

  vendorSha256 = "sha256-c6H/8/dmCWasFKVR15U/kty4AzQAqmiL/VLKrPtH+s4=";
  doCheck = false; # some checks requires instant internet connection
  tags = [ "full" ];

  meta = with lib; {
    description = "A Trojan proxy written in Go.";
    homepage = "https://p4gefau1t.github.io/trojan-go/";
    license = licenses.gpl3;
  };
}
