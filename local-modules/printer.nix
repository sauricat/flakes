{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      samsung-unified-linux-driver
      cnijfilter2
    ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      samsung-unified-linux-driver
      sane-airscan
    ];
  };
  services.saned.enable = true;
  environment.etc."sane.d/airscan.conf".text = ''
    [devices]
      Samsung C460 Series (SEC30CDA7AAB9A2) = http://192.168.2.10:8018/wsd/scan, WSD
  '';

  environment.systemPackages = with pkgs; [
    system-config-printer
    xsane
    simple-scan
  ];

  services.printing.cups-pdf.enable = true;
}
