{ lib, pkgs, ... }:
let
  myinit = lib.strings.concatStringsSep "\n" [
    "set fish_prompt_pwd_dir_length 0" # make prompt show full path
    (builtins.readFile ./fish/guix_integration.fish)
    (builtins.readFile ./fish/vterm_integration.fish) ];
in
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      # Pride commands
      l = "eza -F -abl"; ls = "eza -F"; lt = "eza -F -abl -s modified";
      g = "git";
      b = "bsdtar";
      t = "trash";

      # Other commands
      n = "nix"; nre = "nix repl '<nixpkgs>'"; nse = "nix search nixpkgs";
      ptree = "procs --tree";
      tree = "exa -TF";

      # FIXME: abbrs cannot be sticked together
      s = "sudo";
      p = "proxychains4";
    };

    functions = {
      # Shortcuts
      setvmdrv = "sudo vmhgfs-fuse .host:/ /mnt -o allow_other";
      hash = "nix-hash --flat --base32 --type sha256 $argv";
      nshp = "nix shell nixpkgs#$argv";
      nr = "nix run nixpkgs#$argv";
      e = ''
        if test -z "$argv"
            set args "-c"
        end
        emacsclient $argv
      '';
      f = "fd $argv /nix/store";
      rm = "echo 'Directly `rm` is disabled, use `trash` (or alias `t`) instead.'";
      rwhich = "which $argv | xargs realpath";
      eman = ''
        emacsclient -e "(man \"$argv\")"
      '';

      # Prompt
      fish_greeting = "";
      fish_prompt = lib.strings.removePrefix "function fish_prompt"
        (lib.strings.removeSuffix "end\n" # stubborn, need further improvement
          (builtins.readFile ./fish/fish_prompt.fish));
    };

    shellInit = myinit;
  };

  programs.zoxide = { enable = true;
                      enableFishIntegration = true; };
  programs.fzf    = { enable = true;
                      enableFishIntegration = true; };
}
