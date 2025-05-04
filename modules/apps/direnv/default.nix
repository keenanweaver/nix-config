{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.direnv;
in
{
  options = {
    direnv = {
      enable = lib.mkEnableOption "Enable direnv in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
