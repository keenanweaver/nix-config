{ lib, config, pkgs, username, ... }:
let
  cfg = config.printing;
in
{
  options = {
    printing = {
      enable = lib.mkEnableOption "Enable printing in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [ hplipWithPlugin ];
        openFirewall = true;
      };
    };
    home-manager.users.${username} = { };
  };
}
