{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.jq;
in
{
  options = {
    jq = {
      enable = mkEnableOption "Enable jq in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.jq = {
        enable = true;
      };
    };
  };
}
