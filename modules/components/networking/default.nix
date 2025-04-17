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
        10.20.1.1 opnsense
        10.20.1.7 UCK-G2
        10.20.20.13 crusader
        10.20.20.30 remorsepi
        10.20.20.31 regretpi
        10.20.20.17 nixos-unraid
        10.20.20.11 bazzite
        10.20.20.29 MiSTer
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
