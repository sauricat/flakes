{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      ark
      dolphin
      gwenview
      # okular
      # spectacle
      bibata-cursors
      kitty
    ];
  services.displayManager.sddm = {
    # theme = pkgs.sddm-sugar-candy + "/share/sddm/themes/sugar-candy";
    settings.Theme.CursorTheme = "Bibata-Modern-Ice";
  };
}
