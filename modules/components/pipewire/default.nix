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
                    "node.description" = "Game capture";
                    "audio.position" = [
                      "FL"
                      "FR"
                    ];
                    "capture.props" = {
                      "media.class" = "Audio/Sink";
                      "node.name" = "Game";
                      "node.description" = "Game";
                    };
                    "playback.props" = {
                      "node.name" = "Game_m";
                      "node.description" = "Game capture";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Music capture";
                    "audio.position" = [
                      "FL"
                      "FR"
                    ];
                    "capture.props" = {
                      "media.class" = "Audio/Sink";
                      "node.name" = "Music";
                      "node.description" = "Music";
                    };
                    "playback.props" = {
                      "node.name" = "Music_m";
                      "node.description" = "Music capture";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "Live-only capture";
                    "audio.position" = [
                      "FL"
                      "FR"
                    ];
                    "capture.props" = {
                      "media.class" = "Audio/Sink";
                      "node.name" = "Live-only";
                      "node.description" = "Live-only";
                    };
                    "playback.props" = {
                      "node.name" = "Live-only_m";
                      "node.description" = "Live-only capture";
                    };
                  };
                }
                {
                  "name" = "libpipewire-module-loopback";
                  "args" = {
                    "node.description" = "VoIP capture";
                    "audio.position" = [
                      "FL"
                      "FR"
                    ];
                    "capture.props" = {
                      "media.class" = "Audio/Sink";
                      "node.name" = "VoIP";
                      "node.description" = "VoIP";
                    };
                    "playback.props" = {
                      "node.name" = "VoIP_m";
                      "node.description" = "VoIP capture";
                    };
                  };
                }
              ];
          };
        };
      };
      wireplumber = {
        enable = true;
        extraConfig = {
          # Static/crackling fix https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
          "51-disable-suspension" = {
            "monitor.alsa.rules" = [
              {
                matches = [
                  { "node.name" = "~alsa_input.*"; }
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
        };
      };
    };

    home-manager.users.${username} = { };
  };
}
