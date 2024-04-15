{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.envfs;
in
{
  options = {
    envfs = {
      enable = mkEnableOption "Enable envfs in NixOS";
    };
  };
  config = mkIf cfg.enable {
    services.envfs.enable = true;
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }:{ };
  };
}
