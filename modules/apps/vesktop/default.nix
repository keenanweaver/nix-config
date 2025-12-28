{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.vesktop;
in
{
  options = {
    vesktop = {
      enable = lib.mkEnableOption "Enable vesktop in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.vesktop = {
        enable = true;
        package = pkgs.vesktop.override { withMiddleClickScroll = true; };
      };
    };
  };
}
