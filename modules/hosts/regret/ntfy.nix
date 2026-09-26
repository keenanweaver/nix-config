{
  configurations.nixos.regret.module =
    { config, ... }:
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
          services.podman.containers.ntfy.homepage.settings.href =
            "https://regret.{{HOMEPAGE_VAR_TAILNET_DNS}}";
          sops.secrets = {
            "ntfy/admin_password_hash" = { };
            "ntfy/ntfybot_password_hash" = { };
          };
        };
      my.tailscaleServe.ntfy.target = "http://127.0.0.1:80";
      networking.firewall.interfaces.${config.host.lanInterface}.allowedTCPPorts = [ 80 ];
    };
}
