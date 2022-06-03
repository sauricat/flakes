{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    emacs
    vim
    wget 
    clash
    fd
    ripgrep
    fish
    firefox
    git
    gnupg
    tree
    home-manager
    librime
    libarchive
  ];
  
  # Flatpak
  services.flatpak.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols

      # CJKV
      noto-fonts-cjk
      hanazono
      source-han-sans source-han-serif source-han-mono
      wqy_microhei wqy_zenhei
      sarasa-gothic
      arphic-ukai arphic-uming
      unfonts-core
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Han Serif SC" ];
        sansSerif = [ "Source Han Sans SC" ];
        monospace = [ "Sarasa Mono SC" ];
        emoji = [ "Noto Emoji" ];
      };
    };
  };
}
