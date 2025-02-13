{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gamemode;
  gamemode-start = (
    pkgs.writeShellApplication {
      name = "gamemode-start";
      runtimeInputs = with pkgs; [
        libnotify
      ];
      text = ''
        notify-send -t 3000 -u low 'GameMode' 'GameMode started' -i applications-games -a 'GameMode'
        #kscreen-doctor output.DP-1.wcg.enable output.DP-1.hdr.enable output.DP-1.brightness.100;
      '';
    }
  );
  gamemode-end = (
    pkgs.writeShellApplication {
      name = "gamemode-end";
      runtimeInputs = with pkgs; [
        libnotify
      ];
      text = ''
        notify-send -t 3000 -u low 'GameMode' 'GameMode stopped' -i applications-games -a 'GameMode'
        #kscreen-doctor output.DP-1.wcg.disable output.DP-1.hdr.disable output.DP-1.brightness.100;
      '';
    }
  );
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
          disable_splitlock = 1;
          inhibit_screensaver = 1;
        };
        cpu = {
          park_cores = "yes";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          amd_performance_level = "high";
        };
        custom = {
          # https://github.com/Electrostasy/dots/blob/master/hosts/terra/gaming.nix
          start = "${lib.getBin gamemode-start}/bin/gamemode-start";
          end = "${lib.getBin gamemode-end}/bin/gamemode-end";
        };
      };
    };

    users.users.${username}.extraGroups = [ "gamemode" ];

    home-manager.users.${username} = { };
  };
}
