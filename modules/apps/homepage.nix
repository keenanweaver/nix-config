{
  flake.modules = {
    homeManager.profile-server =
      {
        lib,
        config,
        osConfig,
        ...
      }:
      {
        nps.stacks.homepage.enable = true;
        services.podman.containers.homepage.extraEnv = {
          HOMEPAGE_ALLOWED_HOSTS = lib.mkForce {
            fromTemplate = "${osConfig.networking.hostName}.{{ file.Read `${
              config.sops.secrets."tailscale/tailnet_dns".path
            }` }}:3000,${config.services.podman.containers.homepage.traefik.serviceHost}";
          };
          HOMEPAGE_VAR_TAILNET_DNS.fromFile = config.sops.secrets."tailscale/tailnet_dns".path;
        };
      };
    nixos.profile-server =
      { config, ... }:
      {
        networking.firewall.interfaces = {
          ${config.host.lanInterface}.allowedTCPPorts = [ 3000 ];
          tailscale0.allowedTCPPorts = [ 3000 ];
        };
      };
  };
}
