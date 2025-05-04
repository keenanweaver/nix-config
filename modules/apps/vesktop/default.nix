{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.vesktop;
in
{
  options = {
    vesktop = {
      enable = lib.mkEnableOption "Enable vesktop in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.vesktop = {
        enable = true;
        package = (pkgs.vesktop.override { withMiddleClickScroll = true; });
        settings = {
          appBadge = false;
          arRPC = true;
          checkUpdates = false;
          customTitleBar = false;
          disableMinSize = true;
          discordBranch = "stable";
          hardwareAcceleration = true;
          minimizeToTray = false;
          tray = false;
          splashTheming = true;
          staticTitle = true;
        };
        vencord = {
          settings = {
            autoUpdate = true;
            autoUpdateNotification = false;
            enabledThemes = [ "mocha.theme.css" ];
            notifyAboutUpdates = false;
            transparent = true;
          };
        };
      };
    };
  };
}
