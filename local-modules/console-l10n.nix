{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    extraConfig = "font-size=20";
  };
}
