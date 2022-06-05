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
      l = "ls -ahl"; lt = "ls -Ahltr";
      g = "git";
      b = "bsdtar";
      t = "trash"; 

      # Other commands
      f = "find /nix/store -name";
      n = "nix"; nre = "nix repl '<nixpkgs>'"; nse = "nix search nixpkgs";
      
      # FIXME: abbrs cannot be sticked together
      s = "sudo";
      p = "proxychains4"; 
    };

    functions = {
      # Shortcuts
      setvmdrv = "sudo vmhgfs-fuse .host:/ /mnt -o allow_other";
      ptree = "procs --tree";
      hash = "nix-hash --flat --base32 --type sha256 $argv";
      nshp = "nix shell nixpkgs#$argv";
      rm = "echo 'Directly `rm` is disabled, use `trash` (or alias `t`) instead.'";
      rwhich = "which $argv | xargs realpath";

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
