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
  options = {
    gsr = {
      enable = lib.mkEnableOption "Enable gsr in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gpu-screen-recorder = {
      enable = true;
      packages = pkgs.gsr;
    };

    home-manager.users.${username} =
      { pkgs, config, ... }:
      let
        outputDir = "${config.home.homeDirectory}/Videos";
      in
      {
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "gsr-save-replay";
            runtimeInputs = [
              killall
              libnotify
            ];
            text = ''
              killall -SIGUSR1 gpu-screen-recorder
              notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay saved to <br /> ${outputDir}' -i com.dec05eba.gpu_screen_recorder -a 'GPU Screen Recorder'
            '';
          })
          (writeShellApplication {
            name = "gsr-stop-replay";
            runtimeInputs = [
              killall
              libnotify
            ];
            text = ''
              killall -SIGINT gpu-screen-recorder
              notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay stopped' -i com.dec05eba.gpu_screen_recorder -a 'GPU Screen Recorder'
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
        systemd = {
          user = {
            services = {
              "gpu-screen-recorder" = {
                Unit = {
                  Description = "GPU Screen Recorder Service";
                  PartOf = [ "pipewire.service" ]; # Restart GSR when Pipewire restarts
                };
                Service = {
                  Environment = [
                    "WINDOW=DP-1" # Primary monitor
                    "CONTAINER=mkv"
                    "QUALITY=very_high"
                    "FRAMERATE=60"
                    "FRAMERATE_MODE=vfr"
                    "CODEC=av1"
                    "AUDIO_CODEC=opus"
                    "AUDIO_DEVICE_DEFAUlT="
                    "AUDIO_DEVICE_BROWSER=Browser.monitor"
                    "AUDIO_DEVICE_GAME=Game.monitor"
                    "AUDIO_DEVICE_MIC=mono-microphone"
                    "AUDIO_DEVICE_VOIP=Voice.monitor"
                    "AUDIO_DEVICE_LIVE=Live.monitor"
                    "AUDIO_DEVICE_MUSIC=Music.monitor"
                    "REPLAYDURATION=900"
                    "OUTPUTDIR=${outputDir}"
                    "MAKEFOLDERS=no"
                    "FPSPPS=no"
                  ];
                  ExecStartPre = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay started' -i com.dec05eba.gpu_screen_recorder -a 'GPU Screen Recorder'";
                  ExecStart = "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w $WINDOW -c $CONTAINER -q $QUALITY -f $FRAMERATE -fm $FRAMERATE_MODE -k $CODEC -ac $AUDIO_CODEC -r $REPLAYDURATION -v $FPSPPS -mf $MAKEFOLDERS -a $AUDIO_DEVICE_DEFAUlT -a $AUDIO_DEVICE_GAME -a $AUDIO_DEVICE_MIC -a $AUDIO_DEVICE_BROWSER -a $AUDIO_DEVICE_VOIP -a $AUDIO_DEVICE_MUSIC -a $AUDIO_DEVICE_LIVE -o $OUTPUTDIR";
                  KillSignal = "SIGINT";
                  Restart = "on-failure";
                  RestartSec = "5";
                  Type = "simple";
                };
                Install = {
                  WantedBy = [ "graphical-session.target" ];
                };
              };
            };
          };
        };
      };
  };
}
