# From https://github.com/matt1432/nixos-configs/blob/master/devices/binto/modules/gpu-replay.nix
{ pkgs, config, lib, inputs, username, ... }:
let
  cfg = config.gpu-screen-recorder;
  gsr = pkgs.stdenv.mkDerivation {
    name = "gpu-screen-recorder";
    version = inputs.gpu-screen-recorder-src.shortRev;

    src = inputs.gpu-screen-recorder-src;

    nativeBuildInputs = with pkgs; [
      pkg-config
      makeWrapper
    ];

    buildInputs = with pkgs; [
      libpulseaudio
      ffmpeg
      wayland
      libdrm
      libva
      xorg.libXcomposite
      xorg.libXrandr
    ];

    buildPhase = ''
      ./build.sh
    '';

    installPhase = ''
      strip gsr-kms-server
      strip gpu-screen-recorder

      install -Dm755 "gsr-kms-server" "$out/bin/gsr-kms-server"
      install -Dm755 "gpu-screen-recorder" "$out/bin/gpu-screen-recorder"

      wrapProgram $out/bin/gpu-screen-recorder --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        pkgs.addOpenGLRunpath.driverLink
        pkgs.libglvnd
      ]}"
    '';
  };
in
{
  options = {
    gpu-screen-recorder = {
      enable = lib.mkEnableOption "Enable gpu-screen-recorder in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    security.wrappers = {
      gpu-screen-recorder = {
        owner = "root";
        group = "video";
        capabilities = "cap_sys_nice+ep";
        source = "${gsr}/bin/gpu-screen-recorder";
      };

      gsr-kms-server = {
        owner = "root";
        group = "video";
        capabilities = "cap_sys_admin+ep";
        source = "${gsr}/bin/gsr-kms-server";
      };
    };

    home-manager.users.${username} = { username, pkgs, ... }: {
      home = {
        file = {
          script-gsr-save-replay = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              killall -SIGUSR1 .gpu-screen-recorder
              notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay saved' --icon=com.dec05eba.gpu_screen_recorder --app-name='GPU Screen Recorder'
            '';
            target = ".local/bin/gsr-save-replay.sh";
            executable = true;
          };
          script-gsr-stop-replay = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              systemctl --user stop gpu-screen-recorder.service
              killall -SIGINT .gpu-screen-recorder
              notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay stopped' --icon=com.dec05eba.gpu_screen_recorder --app-name='GPU Screen Recorder'
            '';
            target = ".local/bin/gsr-stop-replay.sh";
            executable = true;
          };
        };
        packages = [ gsr ];
      };
      systemd = {
        user = {
          services = {
            "gpu-screen-recorder" = {
              Unit = {
                Description = "GPU Screen Recorder Service";
              };
              Service = {
                Environment = [
                  "WINDOW=DP-1" # Primary monitor
                  #"SIZE=2560x1440" -s $SIZE
                  "CONTAINER=mkv"
                  "QUALITY=ultra"
                  "FRAMERATE=60"
                  "MODE=cfr"
                  "CODEC=av1"
                  "AUDIO_CODEC=opus"
                  "AUDIO_DEVICE_DEFAUlT=DAC/alsa_output.usb-Schiit_Audio_USB_Modi_Device-00.analog-stereo.monitor"
                  "AUDIO_DEVICE_GAME=Game/Game.monitor"
                  "AUDIO_DEVICE_MIC=mono-microphone"
                  "AUDIO_DEVICE_VOIP=VoIP/VoIP.monitor"
                  "AUDIO_DEVICE_MUSIC=Music/Music.monitor"
                  "REPLAYDURATION=900"
                  "OUTPUTDIR=/home/${username}/Videos"
                  "MAKEFOLDERS=no"
                  "FPSPPS=no"
                ];
                ExecStartPre = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GPU Screen Recorder' 'Replay started' --icon=com.dec05eba.gpu_screen_recorder --app-name='GPU Screen Recorder'";
                ExecStart = "/run/wrappers/bin/gpu-screen-recorder -w $WINDOW -c $CONTAINER -q $QUALITY -f $FRAMERATE -fm $MODE -k $CODEC -ac $AUDIO_CODEC -r $REPLAYDURATION -v $FPSPPS -mf $MAKEFOLDERS -a $AUDIO_DEVICE_DEFAUlT -a $AUDIO_DEVICE_GAME -a $AUDIO_DEVICE_MIC -a $AUDIO_DEVICE_VOIP -a $AUDIO_DEVICE_MUSIC -o $OUTPUTDIR";
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
