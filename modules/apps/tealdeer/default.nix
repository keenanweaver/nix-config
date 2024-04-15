{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.tealdeer;
in
{
  options = {
    tealdeer = {
      enable = mkEnableOption "Enable tealdeer in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.tealdeer.enable = true;
    };
  };
}
