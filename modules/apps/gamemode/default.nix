{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.gamemode;
in
{
  options = {
    gamemode = {
      enable = mkEnableOption "Enable gamemode in NixOS & home-manager";
      customStart = mkOption {
        type = types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode started' --icon=applications-games --app-name='GameMode'"; # & qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.suspend
      };
      customStop = mkOption {
        type = types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode stopped' --icon=applications-games --app-name='GameMode'"; # & qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.resume
      };
    };
  };
  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          desiredgov = "performance";
          inhibit_screensaver = 1;
        };
        custom = {
          start = cfg.customStart;
          stop = cfg.customStop;
        };
      };
    };
    users = {
      groups.gamemode = { };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
