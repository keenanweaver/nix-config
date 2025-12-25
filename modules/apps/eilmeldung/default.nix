{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.eilmeldung;
in
{
  options = {
    eilmeldung = {
      enable = lib.mkEnableOption "Enable eilmeldung in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.eilmeldung = {
        enable = true;
        settings = {
          refresh_fps = 60;
          article_scope = "all";
        };
      };
    };
  };
}
