{
  configurations.nixos.remorse.module =
    { lib, config, ... }:
    {
      home-manager.users.${config.my.user} = { config, pkgs, ... }: {
        nps.stacks.freshrss = {
          enable = true;
          adminProvisioning = {
            enable = true;
            apiPasswordFile = config.sops.secrets."freshrss/admin_api_password".path;
            email = "keenan@remorse.local";
            passwordFile = config.sops.secrets."freshrss/admin_password".path;
          };
        };
        services.podman.containers.freshrss.volumeMap.opml =
          "${../../../assets/hosts/remorse/freshrss-feeds.opml}:/import/feeds.opml:ro";
        sops.secrets = {
          "freshrss/admin_api_password" = { };
          "freshrss/admin_password" = { };
        };
        systemd.user.services.freshrss-import-feeds = {
          Service = {
            ExecStart = "${lib.getExe pkgs.podman} exec freshrss php cli/import-for-user.php --user=admin --filename=/import/feeds.opml";
            Type = "oneshot";
          };
          Unit = {
            After = [ "podman-freshrss.service" ];
            Description = "Reconcile FreshRSS feed subscriptions from the declared OPML file";
          };
        };
        systemd.user.timers.freshrss-import-feeds = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnBootSec = "2m";
            OnUnitActiveSec = "30m";
          };
          Unit.Description = "Periodically reconcile FreshRSS feeds from declared OPML";
        };
      };
      networking.firewall.interfaces = {
        end0.allowedTCPPorts = [ 80 ];
        tailscale0.allowedTCPPorts = [ 80 ];
      };
    };
}
