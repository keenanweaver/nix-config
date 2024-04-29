{ lib, config, username, pkgs, ... }:
let
  cfg = config.gamescope;
in
{
  options = {
    gamescope = {
      enable = lib.mkEnableOption "Enable gamescope in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope_git; # Chaotic package
      capSysNice = true;
    };
    home-manager.users.${username} = { };
  };
}
