{
  lib,
  config,
  username,
  pkgs,
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
        192.168.1.7 unifi
        192.168.1.13 crusader
        192.168.1.30 remorsepi
        192.168.1.31 regretpi
        192.168.1.111 bazzite
        192.168.1.112 mister
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
