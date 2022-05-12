{ config, pkgs, ... }:

{
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  systemd.services.clashClient = {
    wantedBy = [ "multi-user.target" ]; 
    after = [ "network.target" ];
      description = "Clash client service.";
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}