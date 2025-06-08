{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.lazydocker;
in
{
  options = {
    lazydocker = {
      enable = lib.mkEnableOption "Enable lazydocker in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.lazydocker = {
        enable = true;
      };
    };
  };
}
