{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user}.nps.stacks.homepage.enable = true;
      networking.firewall.interfaces = {
        end0.allowedTCPPorts = [ 3000 ];
        tailscale0.allowedTCPPorts = [ 3000 ];
      };
    };
}
