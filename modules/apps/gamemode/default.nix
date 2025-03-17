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
      runtimeEnv = {
        gamemodeStatus = "started";
        vcacheMode = "cache";
        vcachePath = "/sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode";
      };
      runtimeInputs = with pkgs; [
        libnotify
      ];
      text = ''
        notify-send -t 3000 -u low "GameMode" "GameMode $gamemodeStatus" -i applications-games -a "GameMode"
        echo $vcacheMode | sudo tee $vcachePath
      '';
    }
  );
  gamemode-end = (
    pkgs.writeShellApplication {
      name = "gamemode-end";
      runtimeEnv = {
        gamemodeStatus = "stopped";
        vcacheMode = "frequency";
        vcachePath = "/sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode";
      };
      runtimeInputs = with pkgs; [
        libnotify
      ];
      text = ''
        notify-send -t 3000 -u low "GameMode" "GameMode $gamemodeStatus" -i applications-games -a "GameMode"
        echo $vcacheMode | sudo tee $vcachePath
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
          ioprio = 0;
          renice = 10;
          softrealtime = "auto";
        };
        cpu = {
          park_cores = "yes";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          amd_performance_level = "high";
          gpu_device = "1"; # Set when integrated GPU is unavailable
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
