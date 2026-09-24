{
  flake.modules.nixos.profile-server =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      tailscale = lib.getExe pkgs.tailscale;
    in
    {
      config.systemd.services = lib.mapAttrs' (
        name: cfg:
        lib.nameValuePair "${name}-tailscale-serve" {
          after = [ "tailscaled.service" ];
          description = "Proxy ${cfg.displayName} over Tailscale HTTPS via tailscale serve";
          serviceConfig = {
            ExecStart = "${tailscale} serve --bg --https=${toString cfg.httpsPort} ${cfg.target}";
            ExecStop = "${tailscale} serve --https=${toString cfg.httpsPort} off";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = "2s";
            Type = "oneshot";
          };
          startLimitIntervalSec = 0;
          wantedBy = [ "multi-user.target" ];
          wants = [ "tailscaled.service" ];
        }
      ) config.my.tailscaleServe;
      options.my.tailscaleServe = lib.mkOption {
        default = { };
        description = "Local HTTP services to expose via `tailscale serve`, keyed by unit name prefix.";
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                displayName = lib.mkOption {
                  default = name;
                  type = lib.types.str;
                };
                httpsPort = lib.mkOption {
                  default = 443;
                  type = lib.types.port;
                };
                target = lib.mkOption {
                  example = "http://127.0.0.1:80";
                  type = lib.types.str;
                };
              };
            }
          )
        );
      };
    };
}
