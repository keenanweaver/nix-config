{ lib, config, username, pkgs, ... }:
let
  cfg = config.mullvad;
in
{
  options = {
    mullvad = {
      enable = lib.mkEnableOption "Enable mullvad in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };
    home-manager.users.${username} = { };
  };
}
