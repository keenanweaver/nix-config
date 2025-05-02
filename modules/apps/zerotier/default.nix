{
  lib,
  config,
  ...
}:
let
  cfg = config.zerotier;
  adapter = "ztmosnophz";
in
{
  options = {
    zerotier = {
      enable = lib.mkEnableOption "Enable zerotier in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        allowedUDPPorts = [ 9993 ];
      };
      # https://github.com/gomaaz/Zerotier_Gaming_Fix#-considerations-for-gaming-with-linux-and-mac-friends
      # https://discuss.zerotier.com/t/lan-game-server-not-visible-through-zerotier-local-lan-works/12166/7
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
        joinNetworks = [
          "60ee7c034aab3fb3" # Vagabond Gaming Network
        ];
      };
    };
  };
}
