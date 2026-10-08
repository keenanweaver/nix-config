{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.stream-controller =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        dataDir = config.programs.streamcontroller.dataPath;
        nukedKey = media: {
          actions = [
            {
              comment = "Toggle Nuked SC-55";
              id = "com_core447_OSPlugin::RunCommand";
              settings = {
                command = "${config.home.profileDirectory}/bin/nuked-sc55-toggle";
                detached = true;
              };
            }
          ];
          label.bottom.text = "NUKED";
          media.path = "${dataDir}/assets/${media}";
        };
        papirus = "${
          pkgs.catppuccin-papirus-folders.override { inherit (config.catppuccin) accent flavor; }
        }/share/icons/Papirus-Dark/64x64/apps";
        serial = "A00SA4442PRLWM";
      in
      {
        imports = [ inputs.streamcontroller-nix.homeModules.default ];
        assertions = [
          {
            assertion = config.home.file ? "Games/toggle-hdr.sh" && config.home.file ? "Games/toggle-vrr.sh";
            message = "stream-controller binds ~/Games/toggle-{hdr,vrr}.sh, which profile-gaming provides on KDE hosts.";
          }
          {
            assertion = lib.any (pkg: lib.getName pkg == "nuked-sc55-toggle") config.home.packages;
            message = "stream-controller binds nuked-sc55-toggle, which profile-gaming provides.";
          }
        ];
        programs.streamcontroller = {
          enable = true;
          assets = {
            "fooyin.svg" = "${papirus}/org.fooyin.fooyin.svg";
            "mumble.svg" = "${papirus}/mumble.svg";
            "piano-off.png" = pkgs.runCommand "piano-off.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
              magick -background none -density 384 ${papirus}/vmpk.svg -resize 256x256 \
                -colorspace Gray -channel A -evaluate multiply 0.4 +channel $out
            '';
            "piano.svg" = "${papirus}/vmpk.svg";
          };
          defaultPages.${serial} = "Default";
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
                media.path = "${dataDir}/assets/fooyin.svg";
              };
              "3x0".states = {
                "0" = nukedKey "piano-off.png";
                "1" = nukedKey "piano.svg";
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
        systemd.user.services.streamcontroller-nuked-sc55-state = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = lib.getExe (
            pkgs.writeShellApplication {
              name = "streamcontroller-nuked-sc55-state";
              runtimeInputs = with pkgs; [
                glib
                procps
              ];
              text = ''
                last=""
                while true; do
                  if pgrep -x nuked-sc55 >/dev/null; then state=1; else state=0; fi
                  owner="$(gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus \
                    --method org.freedesktop.DBus.GetNameOwner com.core447.StreamController 2>/dev/null || true)"
                  if [ -n "$owner" ] && [ "$state$owner" != "$last" ]; then
                    [ "$owner" = "''${last#?}" ] || sleep 5
                    gdbus call --session --dest com.core447.StreamController --object-path /com/core447/StreamController \
                      --method org.gtk.Actions.Activate change_state "[<['${serial}', 'Default', '3,0', '$state']>]" "{}" >/dev/null \
                      && last="$state$owner"
                  fi
                  sleep 1
                done
              '';
            }
          );
          Unit = {
            After = [ "graphical-session.target" ];
            Description = "Show whether Nuked SC-55 is running on its Stream Deck key";
            PartOf = [ "graphical-session.target" ];
          };
        };
      };
    nixos.stream-controller =
      { ... }:
      {
        imports = [ inputs.streamcontroller-nix.nixosModules.default ];
        home-manager.sharedModules = [ self.modules.homeManager.stream-controller ];
        nixpkgs.overlays = [ inputs.streamcontroller-nix.overlays.default ];
        programs.streamcontroller = {
          enable = true;
          autostart = true;
        };
      };
  };
  flake-file.inputs.streamcontroller-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/streamcontroller-nix";
  };
}
