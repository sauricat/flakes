{ config, pkgs, lib, ... }:
let
  cfg = config.services.guix-daemon;
in
{
  options = {
    services.guix-daemon = {
      enable = lib.mkEnableOption "Guix Daemon";
      environmentValues = lib.mkOption {
        type = lib.types.attrs;
        default = {
          GUIX_LOCPATH = "/var/guix/profiles/per-user/root/guix-profile/lib/locale";
          LC_ALL= "en_US.utf8";
        };
        description = "The environment variables passed to guix-daemon.";
      };
      maxBuildTasks = lib.mkOption {
        type = lib.types.int;
        default = 8192;
        description = ''
          See <https://lists.gnu.org/archive/html/guix-devel/2016-04/msg00608.html>.
          Some package builds (for example, go@1.8.1) may require even more than
          1024 tasks.
        '';
      };
      builders = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "The number of guix builder accounts.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.users =
      builtins.listToAttrs
        (builtins.map
          (index: {
              name = "guixbuilder${builtins.toString index}";
              value= {
                isNormalUser = false;
                isSystemUser = true;
                home = "/var/empty";
                shell = "${pkgs.shadow}/bin/nologin";
                description = "Guix build user ${builtins.toString index}";
                group = "guixbuild";
                extraGroups = [ "guixbuild" ];
              }; })
          (builtins.genList (x: x + 1) cfg.builders));

    systemd.services.guix-daemon = {
      description = "Build daemon for GNU Guix";
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environmentValues;
      serviceConfig = {
        ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
        RemainAfterExit = "yes";
        StandardOutput = "syslog";
        StandardError = "syslog";
        TasksMax = cfg.maxBuildTasks;
      };
    };

    systemd.mounts = lib.singleton {
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
    };
  };
}
