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

    systemd.services.tailscale-optimal =
      let
        tailscale-optimize = (
          pkgs.writeShellApplication {
            name = "tailscale-optimize";
            runtimeInputs = with pkgs; [
              ethtool
              iproute2
            ];
            text = ''
              NETDEV=$(ip -o route get 9.9.9.9 | cut -f 5 -d " ")
              ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off;
            '';
          }
        );
      in
      {
        # https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration
        description = "Optimize tailscale exit node performance";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getBin tailscale-optimize}/bin/tailscale-optimize";
        };
        wantedBy = [ "default.target" ];
      };

    home-manager.users.${username} = {
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
