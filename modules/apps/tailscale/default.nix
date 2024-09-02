{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.tailscale;
in
{
  options = {
    tailscale = {
      enable = lib.mkEnableOption "Enable tailscale in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ config.services.tailscale.port ];
    };

    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
      };
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [ ktailctl ];
    };
  };
}