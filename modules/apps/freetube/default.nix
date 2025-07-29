{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.freetube;
in
{
  options = {
    freetube = {
      enable = lib.mkEnableOption "Enable freetube in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.freetube = {
        enable = true;
        settings = {
          allowDashAv1Formats = true;
          checkForUpdates = false;
          defaultQuality = "1080";
          useSponsorBlock = true;
        };
      };
    };
  };
}
