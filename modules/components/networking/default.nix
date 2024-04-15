{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.networking;
in
{
  options = {
    networking = {
      enable = mkEnableOption "Enable networking in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    networking = {
      extraHosts = ''
        10.20.1.1 opnsense
        10.20.1.7 unifi
        10.20.1.13 crusader
        10.20.1.30 remorsepi
        10.20.1.31 regretpi
        10.20.1.87 freshrss
      '';
      networkmanager = {
        enable = true;
      };
      useDHCP = lib.mkDefault true;
      wireguard.enable = true;
    };

    programs = {
      wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };
    };

    services = {
      resolved.enable = true;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
