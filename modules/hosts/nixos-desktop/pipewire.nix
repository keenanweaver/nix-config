{
  configurations.nixos.nixos-desktop.module = {
    services.pipewire = {
      extraConfig = {
        pipewire = {
          "10-clock" = {
            "context.properties" = {
              "default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
              "default.clock.max-quantum" = 1024;
              # https://reddit.com/r/linux_gaming/comments/1gy347h/newbie_here_ive_tried_almost_all_fixes_theres/lylqijj/?context=3#lylqijj
              "default.clock.min-quantum" = 256;
              "default.clock.quantum" = 256;
              "default.clock.rate" = 48000;
            };
          };
          # Create mono-only microphone output
          "10-loopback-mono-mic" = {
            "context.modules" = [
              {
                "args" = {
                  "capture.props" = {
                    "audio.position" = [ "FL" ];
                    "node.name" = "capture.mono-microphone";
                    "node.passive" = true;
                    "stream.dont-remix" = true;
                    "target.object" =
                      "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo";
                  };
                  "node.description" = "Samson G-Track Pro [MONO]";
                  "playback.props" = {
                    "audio.position" = [ "MONO" ];
                    "media.class" = "Audio/Source";
                    "node.name" = "mono-microphone";
                  };
                };
                "name" = "libpipewire-module-loopback";
              }
            ];
          };
        };
        pipewire-pulse = {
          "10-stutters-fix" = {
            # https://reddit.com/r/linux_gaming/comments/1kafsrz/audio_stutters_fix_clair_obscur_expedition_33_and/
            "pulse.properties" = {
              "pulse.default.req" = "256/48000";
              "pulse.min.frag" = "256/48000";
              "pulse.min.quantum" = "256/48000";
              "pulse.min.req" = "256/48000";
            };
          };
        };
      };
    };
  };
}
