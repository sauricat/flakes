{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # compatibility:
    wine winetricks samba
    steam-run #dpkg apt rpm
    
    # nixos-cn:
    nixos-cn.wine-wechat
    nixos-cn.netease-cloud-music

    # berberman:
    feeluown

    # my own overlay:
    wemeet
  ];
  
  systemd.user.services.killWineWeChat = {
    Unit = {
      Description = "Kill Wine WeChat before shutting down, or it would get stuck.";
      PartOf = "graphical-session.target";
    };
    Service.ExecStop = "${pkgs.procps}/bin/pkill -9 WeChat";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
