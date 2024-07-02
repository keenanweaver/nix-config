{ username, dotfiles, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} =
    { username, ... }:
    {
      programs.plasma = {
        hotkeys = {
          commands = {
            "gsr-save-replay" = {
              name = "Save GSR Replay";
              key = "Meta+Ctrl+|";
              command = "/home/${username}/.local/bin/gsr-save-replay.sh";
              comment = "Save GPU Screen Recorder replay";
            };
          };
        };
        shortcuts = {
          "services/services.gsr-save-replay.sh.desktop"."_launch" = "Meta+Ctrl+|";
        };
        #extraWidgets = [ ];
        panels = [
          # Primary
          {
            height = 54;
            location = "bottom";
            floating = false;
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General = {
                    icon = "${dotfiles}/Pictures/nix-snowflake-white.svg";
                  };
                };
              }
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    showOnlyCurrentDesktop = "false";
                    showOnlyCurrentActivity = "false";
                    showOnlyCurrentScreen = "true";
                    launchers = [
                      "applications:org.kde.dolphin.desktop"
                      "preferred://browser"
                    ];
                  };
                };
              }
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.pager"
              {
                systemTray.items = {
                  hidden = [
                    "opensnitch-ui"
                    "org.kde.plasma.addons.katesessions"
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.clipboard"
                    "org.kde.kdeconnect"
                    "tray-id" # Sunshine
                    #"chrome_status_icon_1" # Armcord
                  ];
                };
              }
              {
                digitalClock = {
                  calendar = {
                    plugins = [ "holidaysevents" ];
                    showWeekNumbers = true;
                  };
                };
              }
              "org.kde.plasma.showdesktop"
            ];
            screen = 0;
          }
          # Secondary
          {
            height = 54;
            location = "bottom";
            floating = false;
            widgets = [
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    showOnlyCurrentDesktop = "false";
                    showOnlyCurrentActivity = "false";
                    showOnlyCurrentScreen = "true";
                    launchers = [
                      "applications:org.codeberg.dnkl.foot.desktop"
                      "applications:org.wezfurlong.wezterm.desktop"
                      "applications:org.signal.Signal.desktop"
                      "applications:xyz.armcord.ArmCord.desktop"
                      "applications:info.mumble.Mumble.desktop"
                      "applications:qobuz.desktop"
                      #"applications:org.strawberrymusicplayer.strawberry.desktop"
                      "applications:foobar2000.desktop"
                      "applications:org.fooyin.fooyin.desktop"
                      "applications:org.kde.neochat.desktop"
                      "applications:org.kde.tokodon.desktop"
                    ];
                  };
                };
              }
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.pager"
              {
                name = "com.github.k-donn.plasmoid-wunderground";
                config = {
                  Station = {
                    stationID = "KNEOMAHA1167";
                  };
                  Units = {
                    unitsChoice = "1";
                  };
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.marginsseparator"
              {
                digitalClock = {
                  calendar = {
                    plugins = [ "holidaysevents" ];
                    showWeekNumbers = true;
                  };
                };
              }
              "org.kde.plasma.showdesktop"
            ];
            screen = 1;
          }
        ];
        window-rules = [
          {
            description = "Move portal windows to primary screen";
            match = {
              window-class = {
                value = "xdg-desktop-portal-kde";
                type = "exact";
                match-whole = false;
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              screen = {
                value = 0;
              };
            };
          }
          {
            description = "armcord";
            match = {
              window-class = {
                value = "armcord";
                type = "regex";
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "0,0";
              };
              screen = {
                value = 1;
                apply = "force";
              };
              size = {
                value = "1026,646";
              };
            };
          }
          {
            description = "foobar2000";
            match = {
              window-class = {
                value = "foobar2000";
                type = "regex";
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "0,646";
                apply = "force";
              };
              screen = {
                value = 1;
              };
              size = {
                value = "1026,740";
              };
            };
          }
          {
            description = "fooyin";
            match = {
              window-class = {
                value = "fooyin";
                type = "regex";
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,646";
              };
              screen = {
                value = 1;
                apply = "force";
              };
              size = {
                value = "1534,741";
              };
            };
          }
          {
            description = "mumble";
            match = {
              window-class = {
                value = "mumble";
                type = "regex";
              };
              window-types = [ "normal" ];
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1723,0";
              };
              screen = {
                value = 1;
                apply = "force";
              };
              size = {
                value = "611,647";
              };
            };
          }
          {
            description = "neochat";
            match = {
              window-class = {
                value = "neochat";
                type = "regex";
                match-whole = false;
              };
            };
            apply = {
              desktops = {
                value = "913f595f-b9b9-46ac-9448-99b3a463d45e"; # Social desktop
              };
              position = {
                value = "1287,0";
              };
              screen = {
                value = 1;
              };
              size = {
                value = "1273,961";
              };
            };
          }
          {
            description = "qobuz";
            match = {
              window-class = {
                value = "qobuz";
                type = "regex";
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,646";
              };
              screen = {
                value = 1;
                apply = "force";
              };
              size = {
                value = "1534,740";
                apply = "force";
              };
            };
          }
          {
            description = "signal";
            match = {
              window-class = {
                value = "signal";
                type = "regex";
              };
            };
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,0";
              };
              screen = {
                value = 1;
                apply = "force";
              };
              size = {
                value = "697,646";
              };
            };
          }
          {
            description = "steam friends list";
            match = {
              window-class = {
                value = "steam";
                type = "exact";
              };
              title = {
                value = "Friends list";
                type = "exact";
              };
            };
            apply = {
              position = {
                value = "2334,0";
                apply = "force";
              };
              screen = {
                value = 1;
                apply = "force";
              };
            };
          }
          {
            description = "tokodon";
            match = {
              window-class = {
                value = "tokodon";
                type = "regex";
                match-whole = false;
              };
            };
            apply = {
              desktops = {
                value = "913f595f-b9b9-46ac-9448-99b3a463d45e"; # Social desktop
              };
              position = {
                value = "0,0";
              };
              screen = {
                value = 1;
              };
              size = {
                value = "1287,961";
              };
            };
          }
        ];
      };
    };
}
