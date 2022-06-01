{ ... }:
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
      c = "code .";
      f = "find /nix/store -name";
      n = "nix"; nse = "nix search nixpkgs";
      
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
      rm = "echo 'Directly `rm` is disabled, use `trash` (or alias `trm`) instead.'";
      gcm = ''
        git commit -m "$argv"
      '';

      # Prompt
      fish_greeting = "";
      fish_prompt = ''
        # Defined originally in /nix/store/vkf0h13wialm2c6i3ylbqnq540gjygvm-fish-3.4.1/share/fish/functions/fish_prompt.fish @ line 4
        # function fish_prompt --description 'Write out the prompt'
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status --background=red white
    
        # Color the prompt differently when we're root        set -l color_cwd $fish_color_cwd
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
      
      # vterm integration
      vterm_printf = ''
        if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end 
            # tell tmux to pass the escape sequences through
            printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
        else if string match -q -- "screen*" "$TERM"
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$argv"
        else
            printf "\e]%s\e\\" "$argv"
        end
      '';
    
    };

    # guix integration
    interactiveShellInit = ''
      set -x PATH $PATH /var/guix/profiles/per-user/root/current-guix/bin/
      set GUIX_LOCPATH $HOME/.guix-profile/lib/locale
    '';


  };
}
