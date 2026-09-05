{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        let
          certDir = "${config.nps.storageBaseDir}/homeassistant/config/tls";
          haCertRenew = pkgs.writeShellApplication {
            name = "homeassistant-cert-renew";
            runtimeInputs = with pkgs; [
              jq
              systemd
              tailscale
            ];
            text = ''
              mkdir -p "${certDir}"
              fqdn=$(tailscale status --json | jq -r '.Self.DNSName' | sed 's/\.$//')
              tailscale cert --cert-file="${certDir}/fullchain.pem" --key-file="${certDir}/privkey.pem" "$fqdn"
              systemctl --user try-restart podman-homeassistant.service
            '';
          };
        in
        {
          home.packages = [ haCertRenew ];
          nps.stacks.homeassistant = {
            enable = true;
            settings.http = {
              ssl_certificate = "/config/tls/fullchain.pem";
              ssl_key = "/config/tls/privkey.pem";
            };
          };
          services.podman.containers.homeassistant = {
            extraConfig.Container = {
              AddCapability = "NET_RAW NET_ADMIN";
              Network = "host";
            };
            volumeMap = lib.mkForce {
              config = "${config.nps.storageBaseDir}/homeassistant/config:/config";
              settings = "${config.nps.stacks.homeassistant.settings}:/config/configuration.yaml";
            };
          };
          systemd.user = {
            services.homeassistant-cert-renew = {
              Service = {
                ExecStart = lib.getExe haCertRenew;
                Type = "oneshot";
              };
              Unit = {
                After = [ "podman-homeassistant.service" ];
                Description = "Renew Tailscale TLS certificate for Home Assistant";
              };
            };
            timers.homeassistant-cert-renew = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnBootSec = "1m";
                OnUnitActiveSec = "1d";
              };
              Unit.Description = "Periodically renew Tailscale TLS certificate for Home Assistant";
            };
          };
        };
      networking.firewall.interfaces = {
        end0.allowedTCPPorts = [ 8123 ];
        tailscale0.allowedTCPPorts = [ 8123 ];
      };
    };
}
