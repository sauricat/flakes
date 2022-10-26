{ config, lib, pkgs, ... }:
let
  copyDir = fromDir: toDir: # fromDir is a path, toDir is a string.
    lib.mapAttrs'
      (name: value: lib.nameValuePair (toDir + "/" + name)
                                      (fromDir + "/${name}"))
      (lib.filterAttrs (name: value: value == "regular")
                       (builtins.readDir fromDir));
  copyDirRecursively = fromDir: toDir:
    builtins.foldl'
      (a: b: a // b)
      (copyDir fromDir toDir)
      (lib.mapAttrsToList (name: value: copyDirRecursively (fromDir + "/${name}")
                                                           (toDir + "/" + name))
                          (lib.filterAttrs (name: value: value == "directory")
                                           (builtins.readDir fromDir)));
  mkHomeFile = fromDir: toDir:
    lib.mapAttrs'
      (name: value: lib.nameValuePair name ({ source = lib.mkDefault value; }))
      (copyDirRecursively fromDir toDir);
in
{
  home.file =
    mkHomeFile ./rime ".config/ibus/rime" //
    mkHomeFile ./emacs ".emacs.d" // {
      ".config/ibus/rime/easy_en.custom.yaml".text = ''
        patch:
          easy_en/use_wordninja_rs: true
          easy_en/wordninja_rs_path: "${pkgs.wordninja-rs}/bin/wordninja"
      '';
    };
}
