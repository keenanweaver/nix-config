{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.navi;
in
{
  options = {
    navi = {
      enable = mkEnableOption "Enable navi in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.navi = {
        enable = true;
      };
    };
  };
}
