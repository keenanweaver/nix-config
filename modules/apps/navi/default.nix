{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.navi;
in
{
  options = {
    navi = {
      enable = lib.mkEnableOption "Enable navi in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.navi = {
        enable = true;
      };
    };
  };
}
