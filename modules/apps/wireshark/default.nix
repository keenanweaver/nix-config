{ lib, config, username, pkgs, ... }:
let
  cfg = config.wireshark;
in
{
  options = {
    wireshark = {
      enable = lib.mkEnableOption "Enable wireshark in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };
    };
    home-manager.users.${username} = { };
  };
}
