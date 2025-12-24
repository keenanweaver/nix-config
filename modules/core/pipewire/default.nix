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
          "11-virtual-devices" =
            let
              mkLoopbackModule = name: {
                "name" = "libpipewire-module-loopback";
                "args" = {
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "capture.props" = {
                    "media.class" = "Audio/Sink";
                    "node.name" = name;
                    "node.description" = name;
                  };
                  "playback.props" = {
                    "node.name" = "${name}_m";
                    "node.description" = name;
                  };
                };
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
              "context.modules" = [ { } ] ++ lib.optionals vars.gaming (map mkLoopbackModule virtualDevices);
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
      wireplumber = {
        enable = true;
        extraConfig = {
          # Static/crackling fix https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
          "51-disable-suspension" = {
            "monitor.alsa.rules" = [
              {
                matches = [
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

    services.pulseaudio.enable = lib.mkForce false;

    home-manager.users.${username} = { };
  };
}
