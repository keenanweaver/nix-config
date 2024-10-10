{
  lib,
  config,
  username,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.pipewire;
in
{
  options = {
    pipewire = {
      enable = lib.mkEnableOption "Enable pipewire in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alsa-firmware
      alsa-lib
      alsa-plugins
      alsa-tools
      alsa-utils
      pulseaudio
    ];

    # https://github.com/NixOS/nixpkgs/issues/330606
    #hardware.alsa.enablePersistence = true;

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      extraConfig = {
        pipewire = {
          "10-loopback-devices" = {
            "context.modules" =
              [ { } ]
              ++ lib.optionals vars.gaming [
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Browser";
                    "capture.props" = {
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "media.class" = "Audio/Sink";
                      "node.name" = "Browser";
                    };
                    "playback.props" = {
                      "node.name" = "Browser";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Game";
                    "capture.props" = {
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "media.class" = "Audio/Sink";
                      "node.name" = "Game";
                    };
                    "playback.props" = {
                      "node.name" = "Game";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Live";
                    "capture.props" = {
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "media.class" = "Audio/Sink";
                      "node.name" = "Live";
                    };
                    "playback.props" = {
                      "node.name" = "Live";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Music";
                    "capture.props" = {
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "media.class" = "Audio/Sink";
                      "node.name" = "Music";
                    };
                    "playback.props" = {
                      "node.name" = "Music";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Voice";
                    "capture.props" = {
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "media.class" = "Audio/Sink";
                      "node.name" = "Voice";
                    };
                    "playback.props" = {
                      "node.name" = "Voice";
                    };
                  };
                }
              ];
          };
        };
        /*
          pipewire-pulse = {
                 # Switch to device on connect https://wiki.archlinux.org/title/PipeWire#Sound_does_not_automatically_switch_when_connecting_a_new_device
                 "switch-on-connect" = {
                   "pulse.cmd" = [
                     {
                       "cmd" = "load-module";
                       "args" = "module-always-sink";
                       flags = [ ];
                     }
                     {
                       "cmd" = "load-module";
                       "args" = "module-switch-on-connect";
                     }
                   ];
                 };
               };
        */
      };
      wireplumber = {
        enable = true;
        extraConfig =
          {
            # Webcam battery drain https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2669
            "10-disable-camera" = {
              "wireplumber.profiles" = {
                main."monitor.libcamera" = "disabled";
              };
            };
            # Disable HDMI audio
            "51-disable-hdmi-audio" = {
              "monitor.alsa.rules" = [
                {
                  matches = [ { "device.name" = "~alsa_output.*.hdmi.*"; } ];
                  actions.update-props = {
                    "device.disabled" = true;
                  };
                }
              ];
            };
            # Static/crackling fix https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
            "51-disable-suspension" = {
              "monitor.alsa.rules" = [
                {
                  matches = [
                    #{ "node.name" = "~alsa_input.*"; }
                    { "node.name" = "~alsa_output.*"; }
                  ];
                  actions.update-props = {
                    "session.suspend-timeout-seconds" = 0;
                  };
                }
              ];
              "monitor.bluez.rules" = [
                {
                  matches = [
                    { "node.name" = "~bluez_input.*"; }
                    { "node.name" = "~bluez_output.*"; }
                  ];
                  actions.update-props = {
                    "session.suspend-timeout-seconds" = 0;
                  };
                }
              ];
            };
          }
          // lib.optionalAttrs vars.gaming {
            "51-disable-dualsense-audio" = {
              "monitor.alsa.rules" = [
                {
                  matches = [
                    { "alsa.card_name" = "Wireless Controller"; }
                  ];
                  actions.update-props = {
                    "node.disabled" = true;
                  };
                }
              ];
            };
          };
      };
    };

    home-manager.users.${username} = { };
  };
}
