{ lib, config, username, ... }:
let
  cfg = config.zerotier;
in
{
  options = {
    zerotier = {
      enable = lib.mkEnableOption "Enable zerotier in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    /*     networking = {
      interfaces = {
        ztmosnophz = {
          # ZeroTier for LAN gaming
          # Can also run: sudo route add -host 255.255.255.255 dev ztmosnophz
          ipv4 = {
            routes = [{
              address = "255.255.255.255";
              prefixLength = 24;
              via = "255.255.255.255";
              options = { metric = "0"; };
            }];
          };
        };
      };
    }; */
    services = {
      zerotierone = {
        enable = true;
        joinNetworks = [
          "60ee7c034aab3fb3" # Vagabond Gaming Network
        ];
      };
    };
    home-manager.users.${username} = { };
  };
}
