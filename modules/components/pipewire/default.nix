{
  lib,
  config,
  username,
  vars,
  pkgs,
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
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
      };
    };

    sound.enable = false;
    home-manager.users.${username} =
      { config, ... }:
      {
        home.file = {
          pipewire-allowed-rates = {
            enable = true;
            text = ''
              context.properties = {
                  default.clock.allowed-rates = [ 44100 48000 88200 96000 ]
              }
            '';
            target = "${config.xdg.configHome}/pipewire/pipewire.conf.d/10-allowed-rates.conf";
          };
          pipewire-coupled-streams = {
            enable = vars.gaming;
            text = ''
              context.modules = [
                  {   name = libpipewire-module-loopback
                      args = {
                              node.description = "Samson G-Track Pro [MONO]"
                              capture.props = {
                                  node.name = "capture.mono-microphone"
                                  audio.position = [ FL ]
                                  target.object = "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo"
                                  stream.dont-remix = true
                                  node.passive = true
                              }
                              playback.props = {
                                  media.class = "Audio/Source"
                                  node.name = "mono-microphone"
                                  audio.position = [ MONO ]
                              }
                          }
                  }
                  {   name = libpipewire-module-loopback
                      args = {
                              node.description = "Game capture"
                              audio.position = [ FL FR ]
                              capture.props = {
                                      media.class = Audio/Sink
                                      node.name = "Game"
                                      node.description = "Game"
                              }
                              playback.props = {
                                      node.name = "Game_m"
                                      node.description = "Game capture"
                              }
                      }
                  }
                  {   name = libpipewire-module-loopback
                      args = {
                              node.description = "Music capture"
                              audio.position = [ FL FR ]
                              capture.props = {
                                      media.class = Audio/Sink
                                      node.name = "Music"
                                      node.description = "Music"
                              }
                              playback.props = {
                                      node.name = "Music_m"
                                      node.description = "Music capture"
                              }
                      }
                  }
                  {   name = libpipewire-module-loopback
                      args = {
                              node.description = "Live-only capture"
                              audio.position = [ FL FR ]
                              capture.props = {
                                      media.class = Audio/Sink
                                      node.name = "Live-only"
                                      node.description = "Live-only"
                              }
                              playback.props = {
                                      node.name = "Live_m"
                                      node.description = "Live-only capture"
                              }
                      }
                  }
                  {   name = libpipewire-module-loopback
                      args = {
                              node.description = "VoIP capture"
                              audio.position = [ FL FR ]
                              capture.props = {
                                      media.class = Audio/Sink
                                      node.name = "VoIP"
                                      node.description = "VoIP"
                              }
                              playback.props = {
                                      node.name = "VoIP_m"
                                      node.description = "VoIP capture"
                              }
                      }
                  }
              ]
            '';
            target = "${config.xdg.configHome}/pipewire/pipewire.conf.d/10-coupled-streams.conf";
          };
          pipewire-echo-cancellation = {
            # https://wiki.archlinux.org/title/PipeWire/Examples#Echo_cancellation
            enable = true;
            text = ''
              context.modules = [
                  {   name = libpipewire-module-echo-cancel
                      args = {
                          monitor.mode = true
                          source.props = {
                              node.name = "source_ec"
                              node.description = "Echo-cancelled source"
                          }
                          aec.args = {
                              webrtc.gain_control = true
                              webrtc.extended_filter = false
                          }
                      }
                  }
              ]
            '';
            target = "${config.xdg.configHome}/pipewire/pipewire.conf.d/60-echo-cancel.conf";
          };
          pipewire-pulseaudio-wine = {
            # https://reddit.com/r/linux_gaming/comments/1d1ef61/pipewire_audio_distortion_and_crackling_fix/
            enable = true;
            text = ''
              pulse.rules = [
                  {
                      matches = [ { application.process.binary = "wine64-preloader" } ]
                      actions = {
                          update-props = {
                              pulse.min.quantum = 1024/48000
                              pulse.min.frag = 1024/48000
                              pulse.min.req = 1024/48000
                          }
                      }
                  }
              ]
            '';
            target = "${config.xdg.configHome}/pipewire/pipewire-pulse.conf.d/10-wine-latency.conf";
          };
          wireplumber-alsa-config = {
            enable = true;
            text = ''
              monitor.alsa.rules = [
                {
                  matches = [
                    {
                      node.name = "~alsa_output.*"
                    }
                  ]
                  actions = {
                    update-props = {
                      api.alsa.period-size   = 1024
                      api.alsa.headroom      = 8192
                    }
                  }
                }
              ]
            '';
            target = "${config.xdg.configHome}/wireplumber/wireplumber.conf.d/50-alsa-config.conf";
          };
          wireplumber-disable-suspend = {
            enable = true;
            text = ''
              monitor.alsa.rules = [
                {
                  matches = [
                    {
                      node.name = "~alsa_input.*"
                    },
                    {
                      node.name = "~alsa_output.*"
                    }
                  ]
                  actions = {
                    update-props = {
                      session.suspend-timeout-seconds = 0
                    }
                  }
                }
              ]
              monitor.bluez.rules = [
                {
                  matches = [
                    {
                      node.name = "~bluez_input.*"
                    },
                    {
                      node.name = "~bluez_output.*"
                    }
                  ]
                  actions = {
                    update-props = {
                      session.suspend-timeout-seconds = 0
                    }
                  }
                }
              ]
            '';
            target = "${config.xdg.configHome}/wireplumber/wireplumber.conf.d/51-disable-suspend.conf";
          };
        };
      };
  };
}
