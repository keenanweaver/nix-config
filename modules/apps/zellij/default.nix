{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.zellij;
in
{
  options = {
    zellij = {
      enable = lib.mkEnableOption "Enable zellij in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
