{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.bat;
in
{
  options = {
    bat = {
      enable = mkEnableOption "Enable bat in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
        ];
      };
    };
  };
}
