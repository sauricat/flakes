{ config, lib, pkgs, ... }:
let
  copyDir = fromDir: toDir: # fromDir is a path, toDir is a string.
    lib.mapAttrs'
      (name: value: lib.nameValuePair (toDir + "/" + name) (fromDir + "/${name}"))
      (lib.filterAttrs (name: value: value == "regular")
        (builtins.readDir fromDir));
  copyDirRecursively = fromDir: toDir:
    builtins.foldl' (a: b: a // b)
      (copyDir fromDir toDir)
      (lib.mapAttrsToList
        (name: value: copyDirRecursively (fromDir + "/${name}") (toDir + "/" + name))
        (lib.filterAttrs (name: value: value == "directory")
          (builtins.readDir fromDir)));
  mkHomeFile = fromDir: toDir:
    lib.mapAttrs'
      (name: value: lib.nameValuePair name ({ source = value; }))
      (copyDirRecursively fromDir toDir);
in
{
  home.file =
    mkHomeFile ./rime ".config/ibus/rime" //
    mkHomeFile ../emacs ".emacs.d" //
    mkHomeFile pkgs.lsp-bridge.outPath ".emacs.d/lsp-bridge" //
    mkHomeFile (pkgs.fetchFromGitHub { owner = "manateelazycat";
                                       repo = "awesome-tray";
                                       rev = "d6cfda96a66a8cb38d27e47087d1a6f8b4249fb8";
                                       sha256 = "sha256-0h6bsyOadU9gE32d13YQT3iVDw/UYztnjSNlDU/m/DM=";})
      ".emacs.d/awesome-tray";
}
