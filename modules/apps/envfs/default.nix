{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.envfs;
in
{
  options = {
    envfs = {
      enable = lib.mkEnableOption "Enable envfs in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    services.envfs.enable = true;
    home-manager.users.${username} = { };
  };
}
