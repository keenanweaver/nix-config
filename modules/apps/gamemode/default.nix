{ lib, config, username, pkgs, ... }:
let
  cfg = config.gamemode;
in
{
  options = {
    gamemode = {
      enable = lib.mkEnableOption "Enable gamemode in NixOS & home-manager";
      customStart = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode started' --icon=applications-games --app-name='GameMode'";
      };
      customStop = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode stopped' --icon=applications-games --app-name='GameMode'";
      };
    };
  };
  config = lib.mkIf cfg.enable {
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
    home-manager.users.${username} = { };
  };
}
