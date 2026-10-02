{ self, ... }:
{
  # https://github.com/gomaaz/Zerotier_Gaming_Fix
  flake.modules.nixos.zerotier =
    { lib, config, ... }:
    let
      inherit (config.host) ztAdapter ztConcurrency;
      networks = [
        "363c67c55a4294ae" # Vagabond Gaming Network
      ];
    in
    {
      assertions = self.lib.mkFactAssertions config [ "ztAdapter" ];
      networking = {
        firewall.interfaces.${ztAdapter}.allowedUDPPortRanges = [
          {
            from = 1;
            to = 65535;
          }
        ];
        interfaces.${ztAdapter}.ipv4.routes = [
          {
            address = "255.255.255.255";
            options.dev = ztAdapter;
            prefixLength = 32;
          }
        ];
      };
      preservation.preserveAt."/persist".directories = [
        "/var/lib/zerotier-one"
      ];
      services.zerotierone = {
        enable = true;
        joinNetworks = networks;
        localConf = {
          concurrency = ztConcurrency;
          cpuPinningEnabled = true;
          multicoreEnabled = true;
        };
      };
      # Fix long boot time
      systemd.services."network-addresses-${ztAdapter}".wantedBy = lib.mkForce [ ];
    };
}
