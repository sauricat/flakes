{ config, pkgs, ... }:

{
  networking.wireless.enable = false;  # Must be false for enabling networkmanager.
  networking.networkmanager.enable = true;
  users.groups."networkmanager".members = [ "shu" ];

  systemd.services.clashClient = {
    description = "Clash client service";
    wantedBy = [ "multi-user.target" ]; 
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "shu";
      ExecStart = "${pkgs.clash}/bin/clash -f /home/shu/clash-configuration/clash.yaml";
      Restart = "on-failure";
      RestartPreventExitStatus = "23";
    };
  };

  networking.proxy.default = "http://127.0.0.1:7890"; 
  # networking.proxy.allProxy = "http://127.0.0.1:7890";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.proxychains = {
    enable = true;
    proxies."clash" = {
      enable = true;
      type = "http";
      host = "127.0.0.1";
      port = 7890;
    };
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
