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

    # https://github.com/piyoki/nixos-config/blob/6f252c3a21faacdc192d9be7598ee6ab17608db7/system/networking/udp-gro-forwarding.nix#L14
    systemd.services."udp-gro-forwarding" =
      let
        swBin = "/run/current-system/sw/bin";
      in
      {
        description = "UDP Gro Forwarding Service";
        after = [
          "network.target"
          "iptables.service"
          "ip6tables.service"
        ];
        serviceConfig = {
          ExecStart = "${pkgs.writeShellScript "udp-gro-forwarding" ''
            set -eux
            NETDEV=$(${swBin}/ip route show 0/0 | grep 'via' | cut -f5 -d ' ')
            ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off;
          ''}";
          Type = "oneshot";
          Environment = [ "PATH=$PATH:${swBin}" ];
        };
        wantedBy = [ "multi-user.target" ];
      };

    home-manager.users.${username} = {
      home.packages = with pkgs; [ ktailctl ];
    };
  };
}
