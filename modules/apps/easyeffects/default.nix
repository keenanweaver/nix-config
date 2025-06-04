{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.easyeffects;
in
{
  options = {
    easyeffects = {
      enable = lib.mkEnableOption "Enable easyeffects in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    home-manager.users.${username} = {
      services.easyeffects = {
        enable = true;
      };
    };
  };
}
