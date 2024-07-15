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
      audio.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        configPackages =
          [
            (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-disable-suspension.conf" ''
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
            '')
          ]
          ++ lib.optionals vars.gaming [
            (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-loopback-devices.conf" ''
              context.modules = [
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
            '')
          ];
      };
    };

    home-manager.users.${username} = { };
  };
}
