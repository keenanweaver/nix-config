{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.home-managerConfig;
in
{
  options = {
    home-managerConfig = {
      enable = mkEnableOption "Enable home-manager in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.home-manager.enable = true;
    };
  };
}
