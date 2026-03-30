{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.rclone;
in
{
  options = {
    rclone = {
      enable = lib.mkEnableOption "Enable rclone in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.rclone = {
        enable = true;
      };
    };
  };
}
