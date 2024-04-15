{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.gamescope;
in
{
  options = {
    gamescope = {
      enable = mkEnableOption "Enable gamescope in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs.gamescope = with pkgs; {
      enable = true;
      package = gamescope_git; # Chaotic package
      capSysNice = true;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
