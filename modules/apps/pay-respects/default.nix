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
    home-manager.users.${username} = {
      programs.pay-respects = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
