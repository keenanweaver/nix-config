{ self, ... }:
let
  inherit (self.lib.site.network) lanSubnet;
  range = {
    from = 1714;
    to = 1764;
  };
in
{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kdePackages.kdeconnect-kde ];
      networking.firewall = {
        extraInputRules = ''
          ip saddr ${lanSubnet} tcp dport ${toString range.from}-${toString range.to} accept
          ip saddr ${lanSubnet} udp dport ${toString range.from}-${toString range.to} accept
        '';
        interfaces.tailscale0 = {
          allowedTCPPortRanges = [ range ];
          allowedUDPPortRanges = [ range ];
        };
      };
    };
}
