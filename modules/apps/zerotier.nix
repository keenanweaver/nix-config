{
  # https://github.com/gomaaz/Zerotier_Gaming_Fix
  flake.modules.nixos.gaming-profile =
    { config, lib, ... }:
    let
      inherit (config.host) ztAdapter ztConcurrency;
      networks = [
        "363c67c55a4294ae" # Vagabond Gaming Network
      ];
    in
    {
      networking = {
        firewall.trustedInterfaces = [ ztAdapter ];
        interfaces.${ztAdapter}.ipv4.routes = [
          {
            options.dev = ztAdapter;
            address = "255.255.255.255";
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
