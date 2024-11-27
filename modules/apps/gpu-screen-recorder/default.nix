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
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gsr ];

    programs.gpu-screen-recorder = {
      enable = true;
      package = pkgs.gsr;
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
                    "WINDOW=portal"
                    "FRAMERATE=60"
                    "FRAMERATE_MODE=content"
                    "VIDEO_CODEC=av1_hdr"
                    "VIDEO_CONTAINER=mp4"
                    "VIDEO_QUALITY=ultra"
                    "COLOR_RANGE=full"
                    "AUDIO_CODEC=opus"
                    "REPLAY_DURATION=900"
                    "RESTORE_PORTAL_SESSION=yes"
                    "OUTPUTDIR=${outputDir}"
                    "AUDIO_DEVICE_DEFAUlT=${cfg.defaultAudioDevice}"
                    "AUDIO_DEVICE_BROWSER=Browser.monitor"
                    "AUDIO_DEVICE_GAME=Game.monitor"
                    "AUDIO_DEVICE_MIC=mono-microphone"
                    "AUDIO_DEVICE_VOICE=Voice.monitor"
                    "AUDIO_DEVICE_LIVE=Live.monitor"
                    "AUDIO_DEVICE_MUSIC=Music.monitor"
                  ];
                  ExecStartPre = "${lib.getBin pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay started' -i com.dec05eba.gpu_screen_recorder -a 'GPU Screen Recorder'";
                  ExecStart = "${lib.getBin pkgs.gsr}/bin/gpu-screen-recorder -w $WINDOW -c $VIDEO_CONTAINER -q $VIDEO_QUALITY -cr $COLOR_RANGE -f $FRAMERATE -fm $FRAMERATE_MODE -k $VIDEO_CODEC -r $REPLAY_DURATION -restore-portal-session $RESTORE_PORTAL_SESSION -o $OUTPUTDIR -a $AUDIO_DEVICE_DEFAUlT -a $AUDIO_DEVICE_GAME -a $AUDIO_DEVICE_MIC -a $AUDIO_DEVICE_BROWSER -a $AUDIO_DEVICE_VOICE -a $AUDIO_DEVICE_MUSIC -a $AUDIO_DEVICE_LIVE";
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
