{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ark
    gnome.nautilus
    gwenview
    kitty
    okular
    spectacle
    bibata-cursors
  ];
  services.xserver.displayManager.sddm = {
    theme = pkgs.sddm-sugar-candy + "/share/sddm/themes/sugar-candy";
    settings.Theme.CursorTheme = "Bibata-Modern-Ice";
  };
}
