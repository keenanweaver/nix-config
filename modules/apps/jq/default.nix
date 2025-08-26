{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.jq;
in
{
  options = {
    jq = {
      enable = lib.mkEnableOption "Enable jq in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.jq = {
        enable = true;
      };
    };
  };
}
