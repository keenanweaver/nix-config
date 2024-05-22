{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gamemode;
in
{
  options = {
    gamemode = {
      enable = lib.mkEnableOption "Enable gamemode in NixOS & home-manager";
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
          # https://github.com/Electrostasy/dots/blob/master/hosts/terra/gaming.nixy
          start = builtins.toString (
            pkgs.writeShellScript "gamemode-start.sh" ''
              ${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode started' --icon=applications-games --app-name='GameMode'
            ''
          );
          end = builtins.toString (
            pkgs.writeShellScript "gamemode-end.sh" ''
              ${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode stopped' --icon=applications-games --app-name='GameMode'
            ''
          );
        };
      };
    };

    users.users.${username}.extraGroups = [ "gamemode" ];

    home-manager.users.${username} = { };
  };
}
