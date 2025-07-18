# Named basics, but actually console-env.
# "mkDefault"s will be overrided by "localisation.nix"
{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # emacs
    wget
    clash-meta
    git
    fd
    ripgrep
    lsof
    tree
    eza
    fish
    gnupg
    home-manager
    libarchive
    zstd
    htop
    iotop
    iftop
    procs
  ];

  programs.command-not-found.enable = lib.mkDefault false;

  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryFlavor = lib.mkDefault "tty";
  # };
}
