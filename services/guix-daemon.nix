
{ config, pkgs, ... }:
{
  systemd.services.guix-daemon = {
    description = "Build daemon for GNU Guix";
    wantedBy = [ "multi-user.target" ]; 
    environment = {
      GUIX_LOCPATH = "/var/guix/profiles/per-user/root/guix-profile/lib/locale";
      LC_ALL= "en_US.utf8";
    };
    serviceConfig = {
      ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
      RemainAfterExit = "yes";
      StandardOutput = "syslog";
      StandardError = "syslog";

      # See <https://lists.gnu.org/archive/html/guix-devel/2016-04/msg00608.html>.
      # Some package builds (for example, go@1.8.1) may require even more than
      # 1024 tasks.
      TasksMax=8192;
    };
  };

  systemd.mounts = [{
    description = "Read-only /gnu/store for GNU Guix";
    unitConfig = {
      before = [ "guix-daemon.service" ];
      DefaultDependencies = "no";
      ConditionPathExists = "/gnu/store";
    };
    wantedBy = [ "guix-daemon.service" ];
    what = "/gnu/store";
    where = "/gnu/store";
    type = "none";
    options = "bind,ro";
  }];
}