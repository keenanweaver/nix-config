{ lib, config, username, ... }:
{
  options = {
    sunshine = {
      enable = lib.mkEnableOption "Enable Sunshine in NixOS";
    };
  };
  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
    };
    home-manager.users.${username} = { };
  };
}
