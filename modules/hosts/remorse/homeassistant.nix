{
  configurations.nixos.remorse.module =
    { config, ... }:
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
      my.tailscaleServe.homeassistant = {
        displayName = "Home Assistant";
        target = "http://127.0.0.1:8123";
      };
      networking.firewall.interfaces.end0.allowedTCPPorts = [ 8123 ];
    };
}
