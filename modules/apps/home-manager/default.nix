{ lib, config, username, ... }:
let
  cfg = config.home-managerConfig;
in
{
  options = {
    home-managerConfig = {
      enable = lib.mkEnableOption "Enable home-manager in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.home-manager.enable = true;
    };
  };
}
