{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.lazygit;
in
{
  options = {
    lazygit = {
      enable = lib.mkEnableOption "Enable lazygit in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
