{
  lib,
  config,
  ...
}:
let
  cfg = config.zerotier;
in
{
  options = {
    zerotier = {
      enable = lib.mkEnableOption "Enable zerotier in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # See here for additional notes https://github.com/gomaaz/Zerotier_Gaming_Fix
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
  };
}
