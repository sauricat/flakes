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
    mkHomeFile ./rime ".local/share/fcitx5/rime" //
    mkHomeFile ./hypr ".config/hypr"//
    mkHomeFile ./squeekboard ".local/share/squeekboard" //
    mkHomeFile ./rofi ".local/share/rofi"//
    mkHomeFile ./emacs ".emacs.d" // {
      ".local/share/fcitx5/rime/easy_en.custom.yaml".text = ''
        patch:
          easy_en/use_wordninja_rs: true
          easy_en/wordninja_rs_path: "${pkgs.wordninja-rs}/bin/wordninja"
      '';
    };
}
