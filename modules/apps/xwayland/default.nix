{ lib, config, username, ... }:
let
  cfg = config.xwayland;
in
{
  options = {
    xwayland = {
      enable = lib.mkEnableOption "Enable xwayland in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      xwayland.enable = true;
    };
    home-manager.users.${username} = { };
  };
}
