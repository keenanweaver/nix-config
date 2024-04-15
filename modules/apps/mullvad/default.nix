{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.mullvad;
in
{
  options = {
    mullvad = {
      enable = mkEnableOption "Enable mullvad in NixOS";
    };
  };
  config = mkIf cfg.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
