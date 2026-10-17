{
  configurations.nixos.regret.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          osConfig,
          ...
        }:
        let
          readSecret = name: "{{ file.Read `${osConfig.sops.secrets.${name}.path}` }}";
        in
        {
          nps.stacks.ntfy = {
            enable = true;
            settings = {
              auth-access = [
                "ntfybot:downloaders:wo"
                "ntfybot:renovate:wo"
              ];
              auth-default-access = "deny-all";
              auth-users = [
                "${config.home.username}:${readSecret "ntfy/admin_password_hash"}:admin"
                "ntfybot:${readSecret "ntfy/ntfybot_password_hash"}:user"
              ];
              cert-file = lib.mkForce "";
              key-file = lib.mkForce "";
              listen-http = ":80";
              listen-https = lib.mkForce "";
            };
          };
          services.podman.containers.ntfy.homepage.settings.href =
            "https://regret.{{HOMEPAGE_VAR_TAILNET_DNS}}";
        };
      my.tailscaleServe.ntfy.target = "http://127.0.0.1:80";
      networking.firewall.interfaces.${config.host.lanInterface}.allowedTCPPorts = [ 80 ];
      sops.secrets = {
        "ntfy/admin_password_hash".owner = config.my.user;
        "ntfy/ntfybot_password_hash".owner = config.my.user;
      };
    };
}
