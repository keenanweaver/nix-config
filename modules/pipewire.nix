{
  flake.modules = {
    nixos.desktop-profile = { lib, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        alsa-firmware
        alsa-lib
        alsa-plugins
        alsa-tools
        alsa-utils
        pulseaudio
      ];

      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        extraConfig = {
          pipewire = {
            "11-virtual-devices" =
              let
                mkLoopbackModule = name: {
                  "args" = {
                    "audio.position" = [
                      "FL"
                      "FR"
                    ];
                    "capture.props" = {
                      "media.class" = "Audio/Sink";
                      "node.description" = "${name} [virtual]";
                      "node.name" = name;
                    };
                    "playback.props" = {
                      "node.name" = "${name}.output";
                      "node.passive" = true;
                      "target.object" = "@DEFAULT_SINK@";
                    };
                  };
                  "name" = "libpipewire-module-loopback";
                };
                virtualDevices = [
                  "Browser"
                  "Game"
                  "Live"
                  "MIDI"
                  "Music"
                  "Voice"
                ];
              in
              {
                "context.modules" = [ { } ] ++ (map mkLoopbackModule virtualDevices);
              };
          };
          pipewire-pulse = {
            "10-resample-quality" = {
              "stream.properties" = {
                "resample.quality" = 10;
              };
            };
          };
        };
        jack.enable = true;
        pulse.enable = true;
        wireplumber = {
          enable = true;
          extraConfig = {
            # Static/crackling fix https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
            "51-disable-suspension" = {
              "monitor.alsa.rules" = [
                {
                  actions.update-props = {
                    "session.suspend-timeout-seconds" = 0;
                  };
                  matches = [
                    { "node.name" = "~alsa_output.*"; }
                  ];
                }
              ];
              "monitor.bluez.rules" = [
                {
                  actions.update-props = {
                    "session.suspend-timeout-seconds" = 0;
                  };
                  matches = [
                    { "node.name" = "~bluez_input.*"; }
                    { "node.name" = "~bluez_output.*"; }
                  ];
                }
              ];
            };
          };
        };
      };
      services.pulseaudio.enable = lib.mkForce false;
    };
    nixos.gaming-profile = {
      services.pipewire = {
        wireplumber = {
          extraConfig = {
            "51-disable-dualsense-audio" = {
              "monitor.alsa.rules" = [
                {
                  actions.update-props = {
                    "node.disabled" = true;
                  };
                  matches = [
                    { "alsa.card_name" = "Wireless Controller"; }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
