{
  configurations.nixos.remorse.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home-manager.users.${config.my.user} =
        { lib, config, ... }:
        {
          nps.stacks.homeassistant = {
            enable = true;
            settings.http = {
              trusted_proxies = lib.mkForce [
                "127.0.0.1/32"
                "::1/128"
              ];
              use_x_forwarded_for = lib.mkForce true;
            };
          };
          services.podman.containers.homeassistant = {
            extraConfig.Container = {
              AddCapability = "NET_RAW NET_ADMIN";
              Network = "host";
            };
            homepage.settings.href = "https://remorse.{{HOMEPAGE_VAR_TAILNET_DNS}}";
            volumeMap = lib.mkForce {
              config = "${config.nps.storageBaseDir}/homeassistant/config:/config";
              settings = "${config.nps.stacks.homeassistant.settings}:/config/configuration.yaml";
            };
          };
        };
      networking.firewall.interfaces.end0.allowedTCPPorts = [ 8123 ];
      systemd.services.homeassistant-tailscale-serve = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "tailscaled.service"
          "podman-homeassistant.service"
        ];
        wants = [
          "tailscaled.service"
          "podman-homeassistant.service"
        ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.tailscale} serve --bg --https=443 http://127.0.0.1:8123";
          ExecStop = "${lib.getExe pkgs.tailscale} serve --https=443 off";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "2s";
          Type = "oneshot";
        };
        startLimitIntervalSec = 0;
        unitConfig.Description = "Proxy Home Assistant over Tailscale HTTPS via tailscale serve";
      };
    };
}
