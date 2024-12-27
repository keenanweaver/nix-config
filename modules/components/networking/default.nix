{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.networking;
in
{
  options = {
    networking = {
      enable = lib.mkEnableOption "Enable networking in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {

    environment = {
      systemPackages = [ ];
    };
    networking = {
      extraHosts = ''
        192.168.1.1 opnsense
        192.168.1.7 UCK-G2
        192.168.20.13 crusader
        192.168.20.30 remorsepi
        192.168.20.31 regretpi
        192.168.20.11 bazzite
        192.168.20.29 MiSTer
      '';
      networkmanager = {
        enable = true;
      };
      useDHCP = lib.mkDefault true;
      wireguard.enable = true;
    };

    home-manager.users.${username} = { };
  };
}
