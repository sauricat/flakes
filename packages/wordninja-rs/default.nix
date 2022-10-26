{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, udev
}:
rustPlatform.buildRustPackage rec {
  pname = "wordninja-rs";
  version = "20210324";
  src = fetchFromGitHub {
    owner = "chengyuhui";
    repo = pname;
    rev = "2f7e50a184d1aaafc6c21743dcdf7c218f3b8ca2";
    sha256 = "sha256-O3FA1u7iXrE8hD6NjI/dEbOPefz0YSKAul7rfoIRDcg=";
  };
  cargoHash = "sha256-8jpnLLaJR77A9Y5UX6qUJNluyNzIAerTQQL51GcfVbQ=";
  cargoPatches = [ ./cargo.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];
}
