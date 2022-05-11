{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget 
    clash
    firefox
    git
    home-manager
    open-vm-tools # vmware adaption
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
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Han Serif" ];
        sansSerif = [ "Source Han Sans" ];
        monospace = [ "Fira Code" ];
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
