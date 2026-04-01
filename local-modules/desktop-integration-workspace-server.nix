{ ... }:
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-wayland";
    openFirewall = true;
  };
}
