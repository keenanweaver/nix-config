{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.mumble;
in
{
  options = {
    mumble = {
      enable = lib.mkEnableOption "Enable mumble in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ (mumble.override { speechdSupport = true; }) ];
    };
  };
}
