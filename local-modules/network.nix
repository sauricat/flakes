{ config, pkgs, libs, ... }:

{
  networking.wireless.enable = false;  # Must be false for enabling networkmanager.
  networking.networkmanager = {
    enable = true;
    # wifi.macAddress = "random";
    # ethernet.macAddress = "random";
  };

  systemd.user.services.clashClient = if config.networking.hostName != "wlsn" then {
    description = "Clash client service";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.clash}/bin/clash -f %h/clash-configuration/clash.yaml";
      Restart = "on-failure";
      RestartPreventExitStatus = "23";
    };
  } else {};

  # networking.proxy.default = "" + libs.lists.optional (config.networking.hostName == "iwkr") "http://127.0.0.1:7890";
  # networking.proxy.allProxy = "http://127.0.0.1:7890";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.proxychains = {
    enable = true;
    proxies.clash = {
      enable = true;
      type = "http";
      host = "127.0.0.1";
      port = 7890;
    };
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [ ];
  };
  programs.ssh = {
    extraConfig = ''
      Host Pod042A
          HostName 10.147.17.126
          User kuniklo
      Host *
          PubkeyAcceptedAlgorithms +ssh-rsa
          HostkeyAlgorithms +ssh-rsa
    '';
  };

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
