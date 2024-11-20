{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.pay-respects;
in
{
  options = {
    pay-respects = {
      enable = lib.mkEnableOption "Enable pay-respects in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.pay-respects = {
      enable = true;
    };
    home-manager.users.${username} = { };
  };
}
