{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget 
    clash
    fish
    firefox
    git
    gnupg
    tree
    home-manager
    librime
    p7zip
    # busybox
    open-vm-tools # vmware adaption
    throttled # dlpt
  ];
  
  # Flatpak
  services.flatpak.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      hanazono
      source-han-sans source-han-serif source-han-mono
      wqy_microhei wqy_zenhei
      sarasa-gothic
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Han Serif SC" ];
        sansSerif = [ "Source Han Sans SC" ];
        monospace = [ "Sarasa Mono SC" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

}
