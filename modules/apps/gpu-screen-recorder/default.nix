{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gsr;
in
{
  options.gsr = {
    enable = lib.mkEnableOption "Enable gsr in NixOS";
    defaultAudioDevice = lib.mkOption {
      type = lib.types.str;
    };
    enableFlatpak = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    enableNative = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = lib.mkIf cfg.enableNative {
      gpu-screen-recorder = {
        enable = true;
      };
      gpu-screen-recorder-ui.enable = true;
    };
    services.flatpak = lib.mkIf cfg.enableFlatpak {
      packages = [
        "com.dec05eba.gpu_screen_recorder"
      ];
    };
    systemd.user.services = {
      "gsr-ui" = lib.mkIf cfg.enableFlatpak {
        name = "gsr-ui";
        description = "GPU Screen Recorder UI";
        serviceConfig = {
          ExecStart = "${pkgs.flatpak}/bin/flatpak run com.dec05eba.gpu_screen_recorder gsr-ui";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "graphical-session.target" ];
      };
    };
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "gsr-save-replay";
            runtimeInputs = [
              killall
            ];
            text = ''
              killall -SIGUSR1 gpu-screen-recorder
            '';
          })
        ];
        programs.plasma = {
          hotkeys = {
            commands = {
              "gsr-save-replay" = {
                name = "Save GSR Replay";
                key = "Meta+Ctrl+|";
                command = "gsr-save-replay";
                comment = "Save GPU Screen Recorder replay";
              };
            };
          };
        };
      };
  };
}
