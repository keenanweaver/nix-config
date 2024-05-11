{
  lib,
  config,
  username,
  ...
}:
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
    networking = {
      firewall = {
        allowedUDPPorts = [ 9993 ];
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
    home-manager.users.${username} = { };
  };
}
