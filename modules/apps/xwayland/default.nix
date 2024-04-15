{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.xwayland;
in
{
  options = {
    xwayland = {
      enable = mkEnableOption "Enable xwayland in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs = {
      xwayland.enable = true;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
