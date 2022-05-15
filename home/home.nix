{ config, pkgs, lib, ... }:

{
  home.username = "shu";
  home.homeDirectory = "/home/shu";
  home.packages = with pkgs; [
    ark filelight vlc bc
    firefox tdesktop
    man-pages tealdeer
    okular libreoffice scribusUnstable gimp onlyoffice-bin
    cabal-install ghc gcc gnumake yarn hugo binutils

    wineWowPackages.staging winetricks samba

    dpkg apt steam-run

    # non-oss:
    megasync vscode
  ];
  
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
    functions = {
      fish_greeting = "";
      setvmdrv = "sudo vmhgfs-fuse .host:/ /mnt -o allow_other";
    };
  };
  
  home.stateVersion = "21.11";
  
}
