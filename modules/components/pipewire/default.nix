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
          pipewire-pulseaudio-wine = {
            enable = true;
            text = ''
              pulse.rules = [
                  {
                      matches = [ { application.process.binary = "wine64-preloader" } ]
                      actions = {
                          update-props = {
                              pulse.min.quantum = 1024/48000
                          }
                      }
                  }
              ]
            '';
            target = "${config.xdg.configHome}/pipewire/pipewire-pulse.conf.d/10-wine-latency.conf";
          };
          /*
            wireplumber-bluetooth-config = {
              enable = true;
              text = ''
                bluez_monitor.properties = {
                  ["bluez5.enable-sbc-xq"] = true,
                  ["bluez5.enable-msbc"] = true,
                  ["bluez5.enable-hw-volume"] = true,
                  ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                }
              '';
              target = "${config.xdg.configHome}/wireplumber/bluetooth.lua.d/51-bluez-config.lua";
            };
          */
          wireplumber-disable-suspend = {
            enable = true;
            text = ''
              monitor.alsa.rules = [
                {
                  matches = [
                    {
                      device.name = "~alsa_card.*"
                    }
                  ]
                  actions = { update-props = { } }
                }
                {
                  matches = [
                    {
                      node.name = "~alsa_input.pci.*"
                    }
                    {
                      node.name = "~alsa_output.pci.*"
                    }
                  ]
                  actions = { update-props = { session.suspend-timeout-seconds = 0 } } 
                }
              ]
            '';
            target = "${config.xdg.configHome}/wireplumber/wireplumber.conf.d/51-disable-suspend.conf";
          };
        };
      };
  };
}
