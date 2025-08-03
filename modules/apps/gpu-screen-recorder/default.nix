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
        package =
          with pkgs;
          gpu-screen-recorder.overrideAttrs {
            version = "5.6.4";
            src = fetchgit {
              url = "https://repo.dec05eba.com/gpu-screen-recorder";
              tag = "5.6.4";
              hash = "sha256-is9O0tRMhdkiKzpYa2QI+BmELLFP8WPMTa1LLLtjkxw=";
            };
          };
      };
      gpu-screen-recorder.ui.enable = true;
    };
    services.flatpak = lib.mkIf cfg.enableFlatpak {
      packages = [
        "com.dec05eba.gpu_screen_recorder"
      ];
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
        /*
          systemd.user.services = {
                 "gsr-ui" = lib.mkIf cfg.enableFlatpak {
                   Unit = {
                     Description = "GPU Screen Recorder UI";
                   };
                   Service = {
                     ExecStart = "${pkgs.flatpak}/bin/flatpak run com.dec05eba.gpu_screen_recorder gsr-ui";
                     KillSignal = "SIGINT";
                     Restart = "on-failure";
                     RestartSec = 5;
                     Type = "simple";
                   };
                   Install = {
                     WantedBy = [ "default.target" ];
                     After = [ "graphical-session.target" ];
                   };
                 };
               };
        */
      };
  };
}
