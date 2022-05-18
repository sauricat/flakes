{ inputs, system, config, pkgs, lib, ... }:

{
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = (with pkgs; [
    ark filelight vlc bc procs man-pages tealdeer neofetch
    firefox tdesktop
    okular libreoffice scribusUnstable gimp onlyoffice-bin kate
    cabal-install ghc gcc gnumake yarn hugo binutils 
    xsel cachix zlib 

    # compatibility:
    wine winetricks samba
    dpkg apt steam-run rpm pacman

    # non-oss:
    megasync vscode
  ]) ++ (with inputs.nixos-guix.packages.${system}; [
    nixos-guix
  ]) ++ (with inputs.nixos-cn.legacyPackages.${system}; [
    wine-wechat
  ]);
  
  home.file = lib.attrsets.mapAttrs' (name: value: 
      lib.attrsets.nameValuePair 
        (".config/ibus/rime/${value}") 
        ({ source = config.lib.file.mkOutOfStoreSymlink ./config/ibus-rime/${value}; })){ 
    dc = "default.custom.yaml";
    kb2 = "key_bindings2.yaml";
    sym = "mysymbols.yaml";
    dpys = "double_pinyin_mspy.schema.yaml";
    cs = "chaizi.schema.yaml"; 
    cd = "chaizi.dict.yaml"; 
    ws = "wugniu.schema.yaml";
    wls = "wugniu_lopha.schema.yaml";
    wld = "wugniu_lopha.dict.yaml";
    ls = "langjin.schema.yaml";
    ld = "langjin.dict.yaml";
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "linshu1729@protonmail.com";
    userName = "sauricat";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      l = "ls -ahl";
      g = "git";
      b = "bc -l";
      t = "tar";
    };

    interactiveShellInit = ''
      set -x PATH $PATH /var/guix/profiles/per-user/root/current-guix/bin/
      set GUIX_LOCPATH $HOME/.guix-profile/lib/locale
    '';

    functions = {
      fish_greeting = "";
      setvmdrv = "sudo vmhgfs-fuse .host:/ /mnt -o allow_other";
      ptree = "procs --tree";
      fish_prompt = ''
        # Defined originally in /nix/store/vkf0h13wialm2c6i3ylbqnq540gjygvm-fish-3.4.1/share/fish/functions/fish_prompt.fish @ line 4
        # function fish_prompt --description 'Write out the prompt'
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status --background=red white
    
        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix '>'
        if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            end
            set suffix '#'
        end

        # Write pipestatus
        # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
            set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color $bold_flag $fish_color_status)
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        echo 
        echo -n -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
      '';
    };
  };
  
  home.stateVersion = "21.11";
  
}
