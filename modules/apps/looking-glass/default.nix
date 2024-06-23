{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.looking-glass;
in
{
  options = {
    looking-glass = {
      enable = lib.mkEnableOption "Enable looking-glass in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.looking-glass-client = {
        enable = true;
      };
    };
  };
}
