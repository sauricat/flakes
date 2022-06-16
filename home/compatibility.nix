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
  
  systemd.user.services.killWine = {
    Unit = {
      Description = "Kill Wine and WeChat before shutting down, or it would get stuck.";
      Before = [ "shutdown.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeScript "killwine.sh" ''
          #!${pkgs.runtimeShell}
          ${pkgs.procps}/bin/pkill -9 WeChat
          ${pkgs.procps}/bin/ps -ef | ${pkgs.ripgrep}/bin/rg "C:\\\\" | ${pkgs.ripgrep}/bin/rg -v ${pkgs.ripgrep} | ${pkgs.gawk}/bin/gawk '{ print $2 }' | ${pkgs.findutils}/bin/xargs ${pkgs.util-linux}/bin/kill -9
        ''}";
    };
    Install.WantedBy = [ "shutdown.target" ];
  };
}
