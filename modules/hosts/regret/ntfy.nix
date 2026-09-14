{
  configurations.nixos.regret.module =
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
          nps.stacks.ntfy = {
            enable = true;
            settings = {
              auth-default-access = "deny-all";
              auth-users = [
                "${config.home.username}:{{ file.Read `${
                  config.sops.secrets."ntfy/admin_password_hash".path
                }` }}:admin"
                "ntfybot:{{ file.Read `${config.sops.secrets."ntfy/ntfybot_password_hash".path}` }}:admin"
              ];
              cert-file = lib.mkForce "";
              key-file = lib.mkForce "";
              listen-http = ":80";
              listen-https = lib.mkForce "";
            };
          };
          sops.secrets = {
            "ntfy/admin_password_hash" = { };
            "ntfy/ntfybot_password_hash" = { };
          };
        };
      networking.firewall.interfaces.end0.allowedTCPPorts = [ 80 ];
      systemd.services.ntfy-tailscale-serve = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "tailscaled.service"
          "podman-ntfy.service"
        ];
        wants = [
          "tailscaled.service"
          "podman-ntfy.service"
        ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.tailscale} serve --bg --https=443 http://127.0.0.1:80";
          ExecStop = "${lib.getExe pkgs.tailscale} serve --https=443 off";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "2s";
          Type = "oneshot";
        };
        startLimitIntervalSec = 0;
        unitConfig.Description = "Proxy ntfy over Tailscale HTTPS via tailscale serve";
      };
    };
}
