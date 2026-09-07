{
  flake.modules = {
    homeManager.stream-controller =
      { inputs, config, ... }:
      let
        dataDir = config.programs.streamcontroller.dataPath;
      in
      {
        imports = [ inputs.omniflake.flakes.streamcontroller-nix.homeModules.default ];
        programs.streamcontroller = {
          enable = true;
          assets = {
            "512-fooyin.png" = ../../assets/stream-controller/512-fooyin.png;
            "mumble.svg" = ../../assets/stream-controller/mumble.svg;
          };
          defaultPages."A00SA4442PRLWM" = "Default";
          pages.Default = {
            extraConfig.auto-change = {
              enable = true;
              stay_on_page = true;
              title = "";
              wm_class = "";
            };
            keys = {
              "0x0".states."0".actions = [
                {
                  id = "com_core447_DeckPlugin::ChangePage";
                  settings = {
                    deck_number = null;
                    selected_page = "${dataDir}/plugins/com_core447_VolumeMixer/pages/VolumeMixer.json";
                  };
                }
              ];
              "0x1".states."0" = {
                actions = [
                  {
                    comment = "Mute microphone";
                    id = "com_core447_MicMute::ToggleMute";
                    settings = {
                      all = false;
                      device = "Samson G-Track Pro";
                    };
                  }
                ];
                label.bottom.text = "Mute";
              };
              "0x2".states."0" = {
                actions = [
                  {
                    id = "com_gapls_AudioControl::Mute";
                    settings = {
                      pulse-name = "alsa_output.usb-Schiit_Audio_Schiit_Modi_-00.analog-stereo";
                      show-device-name = false;
                      show-info = false;
                    };
                  }
                ];
                label.bottom.text = "Mute All";
              };
              "1x0".states."0" = {
                actions = [
                  {
                    comment = "Toggle HDR";
                    id = "com_core447_OSPlugin::RunCommand";
                    settings = {
                      command = "${config.home.homeDirectory}/Games/toggle-hdr.sh";
                      detached = true;
                    };
                  }
                ];
                label = {
                  center.text = "";
                  top = {
                    outline_width = 2;
                    text = "HDR";
                  };
                };
              };
              "1x1".states."0" = {
                actions = [
                  {
                    comment = "Run PKill to kill .exe processes";
                    id = "com_core447_OSPlugin::RunCommand";
                    settings.command = "pkill -9 -f '\\.(exe|EXE)$' 2>/dev/null; killall -9 -r '.*\\.(exe|EXE)$' 2>/dev/null; true";
                  }
                ];
                label = {
                  bottom.text = "";
                  top.text = "Kill EXE";
                };
                media.path = "${dataDir}/icons/com_axolotlmaid_FontAwesomeIcons/icons/white/skull.svg";
              };
              "1x2".states."0" = {
                actions = [
                  {
                    id = "com_gapls_AudioControl::Mute";
                    settings = {
                      pulse-name = "Voice";
                      show-device-name = false;
                      show-info = false;
                    };
                  }
                ];
                label.bottom.text = "Mute VoIP";
              };
              "2x0".states."0" = {
                actions = [
                  {
                    comment = "Toggle VRR";
                    id = "com_core447_OSPlugin::RunCommand";
                    settings = {
                      command = "${config.home.homeDirectory}/Games/toggle-vrr.sh";
                      detached = true;
                    };
                  }
                ];
                label = {
                  center.text = "";
                  top = {
                    outline_width = 2;
                    text = "VRR";
                  };
                };
              };
              "2x1".states."0" = {
                actions = [
                  {
                    comment = "Mumble: 'bp fear'";
                    id = "com_core447_OSPlugin::Hotkey";
                    settings.keys = [
                      [
                        42
                        1
                      ]
                      [
                        183
                        1
                      ]
                      [
                        183
                        0
                      ]
                      [
                        42
                        0
                      ]
                    ];
                  }
                ];
                label.center = {
                  font-weight = 400;
                  outline_width = 3;
                  text = "FEAR";
                };
                media.path = "${dataDir}/assets/mumble.svg";
              };
              "2x2".states."0" = {
                actions = [
                  {
                    comment = "Play/Pause";
                    id = "com_core447_MediaPlugin::PlayPause";
                    settings = {
                      player_name = "fooyin";
                      show_label = false;
                      show_thumbnail = false;
                    };
                  }
                ];
                label.top.text = "Play/Stop";
                media.path = "${dataDir}/assets/512-fooyin.png";
              };
              "3x1".states."0" = {
                actions = [
                  {
                    comment = "Mumble: 'bp vine'";
                    id = "com_core447_OSPlugin::Hotkey";
                    settings.keys = [
                      [
                        42
                        1
                      ]
                      [
                        125
                        1
                      ]
                      [
                        184
                        1
                      ]
                      [
                        184
                        0
                      ]
                      [
                        42
                        0
                      ]
                      [
                        125
                        0
                      ]
                    ];
                  }
                ];
                label.center.text = "VINE";
                media.path = "${dataDir}/assets/mumble.svg";
              };
              "4x2".states."0".actions = [
                {
                  id = "com_vesyl_Tailscale::ToggleConnection";
                  settings = { };
                }
              ];
            };
          };
        };
      };
    nixos.stream-controller =
      { inputs, ... }:
      {
        imports = [ inputs.omniflake.flakes.streamcontroller-nix.nixosModules.default ];
        nixpkgs.overlays = [ inputs.omniflake.flakes.streamcontroller-nix.overlays.default ];
        programs.streamcontroller = {
          enable = true;
          autostart = true;
        };
      };
  };
}
