{ lib, pkgs, ... }:

{
  networking.wireless.enable = false;  # Must be false for enabling networkmanager.
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openconnect ];
    # wifi.macAddress = "random";
    # ethernet.macAddress = "random";
  };

  # systemd.user.services.clashClient = if config.networking.hostName != "wlsn" then {
  #   description = "Clash client service";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.clash-meta}/bin/clash -f %h/clash-configuration/clash.yaml";
  #     Restart = "on-failure";
  #     RestartPreventExitStatus = "23";
  #   };
  # } else {};

  # networking.proxy.default = if config.networking.hostName != "wlsn" then "http://127.0.0.1:7890" else "";
  # networking.proxy.allProxy = "http://127.0.0.1:7890";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # programs.proxychains = {
  #   enable = true;
  #   proxies.clash = {
  #     enable = true;
  #     type = "http";
  #     host = "127.0.0.1";
  #     port = 7890;
  #   };
  # };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.ssh = {
    extraConfig = ''
      Host *
          PubkeyAcceptedAlgorithms +ssh-rsa
          HostkeyAlgorithms +ssh-rsa
    '';
  };

  services.tailscale.enable = true;

  networking.firewall = rec {
    enable = lib.mkDefault true;
    checkReversePath = lib.mkDefault "loose";
    allowedTCPPorts = [ 1714 1764 ]; #KDEConnect
    allowedUDPPorts = allowedTCPPorts;
  };

  programs.kdeconnect.enable = true;

}
