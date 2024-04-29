{ lib, config, username, ... }:
let
  cfg = config.cdemu;
in
{
  options = {
    cdemu = {
      enable = lib.mkEnableOption "Enable cdemu in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.cdemu = {
      enable = true;
      gui = false;
      image-analyzer = false;
    };
    home-manager.users.${username} = { };
  };
}
