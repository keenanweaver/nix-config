{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.tealdeer;
in
{
  options = {
    tealdeer = {
      enable = lib.mkEnableOption "Enable tealdeer in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.tealdeer = {
        enable = true;
        settings = {
          display = {
            compact = false;
            use_pager = false;
          };
        };
      };
    };
  };
}
