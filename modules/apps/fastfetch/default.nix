{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.fastfetch;
in
{
  options = {
    fastfetch = {
      enable = lib.mkEnableOption "Enable fastfetch in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.fastfetch = {
        enable = true;
      };
    };
  };
}
