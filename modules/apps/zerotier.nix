{ self, ... }:
{
  # https://github.com/gomaaz/Zerotier_Gaming_Fix
  flake.modules.nixos.zerotier =
    { lib, config, ... }:
    let
      inherit (config.host) ztAdapter ztConcurrency;
      networksFile = config.sops.secrets."zerotier/networks".path;
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
        localConf = {
          concurrency = ztConcurrency;
          cpuPinningEnabled = true;
          multicoreEnabled = true;
        };
      };
      sops.secrets."zerotier/networks" = {
        restartUnits = [ "zerotierone.service" ];
        sopsFile = ../../assets/secrets/desktop.yaml;
      };
      systemd.services = {
        # Fix long boot time
        "network-addresses-${ztAdapter}".wantedBy = lib.mkForce [ ];
        # joinNetworks needs the IDs at eval time, so join from the secret at runtime
        zerotierone.preStart = lib.mkAfter ''
          while read -r id || [ -n "$id" ]; do
            [ -n "$id" ] && touch "/var/lib/zerotier-one/networks.d/$id.conf"
          done < ${networksFile}
        '';
      };
    };
}
