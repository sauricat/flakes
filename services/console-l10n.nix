{ pkgs, ... }:
let
  cjktty-5_15 = {
    name = "cjktty-5.15";
    patch = pkgs.fetchpatch {
      name = "cjktty-5.15.patch";
      url = "https://raw.githubusercontent.com/zhmars/cjktty-patches/2a35e3af97f1de47870096263c8eb101aa58004b/v5.x/cjktty-5.15.patch";
      sha256 = "sha256-jYWYhR/WVBcG8AIKkNIoPc5DzgJSN4f4LfCOut+eyVQ=";
    };
  };
in
{
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15; # fix kernel version
  # boot.kernelPatches = [ cjktty-5_15 ];
  services.kmscon = {
    enable = true;
    extraConfig = "font-size=20";
  };
}
