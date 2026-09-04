{
  configurations.nixos.regret.module =
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
          certDir = "${config.nps.storageBaseDir}/ntfy/certs";
          ntfyCertRenew = pkgs.writeShellApplication {
            name = "ntfy-cert-renew";
            runtimeInputs = with pkgs; [
              jq
              systemd
              tailscale
            ];
            text = ''
              mkdir -p "${certDir}"
              fqdn=$(tailscale status --json | jq -r '.Self.DNSName' | sed 's/\.$//')
              tailscale cert --cert-file="${certDir}/ntfy.crt" --key-file="${certDir}/ntfy.key" "$fqdn"
              systemctl --user try-restart podman-ntfy.service
            '';
          };
        in
        {
          home.packages = [ ntfyCertRenew ];
          nps = {
            externalStorageBaseDir = "${config.home.homeDirectory}/external";
            hostIP4Address = "10.20.20.31";
            stacks.ntfy = {
              enable = true;
              settings = {
                auth-default-access = "deny-all";
                auth-users = [
                  "${config.home.username}:{{ file.Read `${
                    config.sops.secrets."ntfy/admin_password_hash".path
                  }` }}:admin"
                ];
                cert-file = "/var/lib/ntfy/certs/ntfy.crt";
                key-file = "/var/lib/ntfy/certs/ntfy.key";
                listen-http = ":80";
                listen-https = ":443";
              };
            };
          };
          services.podman.containers.ntfy.ports = [ "443:443" ];
          sops.secrets."ntfy/admin_password_hash" = { };
          systemd.user.services.ntfy-cert-renew = {
            Service = {
              ExecStart = lib.getExe ntfyCertRenew;
              Type = "oneshot";
            };
            Unit = {
              After = [ "podman-ntfy.service" ];
              Description = "Renew Tailscale TLS certificate for ntfy";
            };
          };
          systemd.user.timers.ntfy-cert-renew = {
            Install.WantedBy = [ "timers.target" ];
            Timer = {
              OnBootSec = "1m";
              OnUnitActiveSec = "1d";
            };
            Unit.Description = "Periodically renew Tailscale TLS certificate for ntfy";
          };
        };
      networking.firewall.interfaces = {
        end0.allowedTCPPorts = [
          80
          443
        ];
        tailscale0.allowedTCPPorts = [
          80
          443
        ];
      };
    };
}
