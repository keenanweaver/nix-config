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
    environment.systemPackages = with pkgs; [
      ethtool
      tailscale
    ];

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ config.services.tailscale.port ];
    };

    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
        extraSetFlags = [
          "--advertise-exit-node"
        ];
        useRoutingFeatures = "both";
      };
    };

    home-manager.users.${username} =
      { config, ... }:
      {
        home.file = {
          autostart-ktailctl = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=ktailctl
              Name=ktailctl
              Terminal=false
              Type=Application
            '';
            target = "${config.xdg.configHome}/autostart/ktailctl.desktop";
            executable = true;
          };
        };
        home.packages = with pkgs; [ ktailctl ];
      };
  };
}
