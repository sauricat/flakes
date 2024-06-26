{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ark
    dolphin
    gwenview
    kitty
    okular
    # spectacle
    bibata-cursors
  ];
  services.displayManager.sddm = {
    # theme = pkgs.sddm-sugar-candy + "/share/sddm/themes/sugar-candy";
    settings.Theme.CursorTheme = "Bibata-Modern-Ice";
  };
}
