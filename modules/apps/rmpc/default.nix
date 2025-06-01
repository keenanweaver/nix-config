{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.rmpc;
in
{
  options = {
    rmpc = {
      enable = lib.mkEnableOption "Enable rmpc in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.rmpc = {
        enable = true;
      };
    };
  };
}
