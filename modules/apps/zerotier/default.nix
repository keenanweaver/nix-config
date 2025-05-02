{
  lib,
  config,
  ...
}:
let
  cfg = config.zerotier;
  adapter = "ztmosnophz";
  networks = [
    "60ee7c034aab3fb3" # Vagabond Gaming Network
  ];
in
{
  options = {
    zerotier = {
      enable = lib.mkEnableOption "Enable zerotier in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # https://github.com/gomaaz/Zerotier_Gaming_Fix#-considerations-for-gaming-with-linux-and-mac-friends
    # https://discuss.zerotier.com/t/lan-game-server-not-visible-through-zerotier-local-lan-works/12166/7
    networking = {
      interfaces = {
        ${adapter} = {
          ipv4 = {
            routes = [
              {
                address = "255.255.255.255";
                prefixLength = 32;
                options = {
                  dev = "${adapter}";
                };
              }
            ];
          };
        };
      };
    };
    services = {
      zerotierone = {
        enable = true;
        joinNetworks = networks;
      };
    };
    # Fix long boot
    systemd.services = {
      "network-addresses-${adapter}" = {
        before = lib.mkForce [ ];
        wantedBy = lib.mkForce [
          "network-link-${adapter}.service"
          "zerotierone.service"
          "multi-user.target"
        ];
      };
      "network-link-${adapter}" = {
        before = lib.mkForce [ ];
        wantedBy = lib.mkForce [ "multi-user.target" ];
      };
    };
  };
}
