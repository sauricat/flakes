{ config, pkgs, ... }:

{
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

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
