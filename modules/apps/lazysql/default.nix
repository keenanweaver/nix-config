{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.lazysql;
in
{
  options = {
    lazysql = {
      enable = lib.mkEnableOption "Enable lazysql in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.lazysql = {
        enable = true;
      };
    };
  };
}
