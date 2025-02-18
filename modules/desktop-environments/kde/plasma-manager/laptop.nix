{ username, pkgs, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} = {
    programs.plasma = {
      input = {
        mice = [
          {
            enable = true;
            name = "Logitech G903";
            vendorId = "046d";
            productId = "4067";
            leftHanded = false;
            middleButtonEmulation = false;
            accelerationProfile = "none";
            naturalScroll = false;
            scrollSpeed = 1;
          }
        ];
        touchpads = [
          {
            enable = true;
            name = "DELL0B6B:00 04F3:3259 Touchpad";
            vendorId = "04f3";
            productId = "3259";
            disableWhileTyping = true;
            leftHanded = false;
            middleButtonEmulation = false;
            naturalScroll = true;
            pointerSpeed = 0;
            tapToClick = true;
          }
        ];
      };
      panels = [
        {
          height = 54;
          location = "bottom";
          floating = false;
          widgets = [
            {
              kickoff = {
                applicationsDisplayMode = "list";
                compactDisplayStyle = true;
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                favoritesDisplayMode = "grid";
                # pin = true;
                showActionButtonCaptions = true;
                showButtonsFor = "power";
                sortAlphabetically = true;
              };
            }
            {
              iconTasks = {
                appearance = {
                  fill = true;
                  highlightWindows = true;
                  indicateAudioStreams = true;
                  showTooltips = true;
                  rows.multirowView = "never";
                };
                behavior = {
                  grouping = {
                    method = "byProgramName";
                    clickAction = "cycle";
                  };
                  middleClickAction = "newInstance";
                  newTasksAppearOn = "right";
                  showTasks = {
                    onlyInCurrentActivity = false;
                    onlyInCurrentDesktop = false;
                    onlyInCurrentScreen = true;
                    onlyMinimized = false;
                  };
                  sortingMethod = "manually";
                  unhideOnAttentionNeeded = true;
                  wheel = {
                    switchBetweenTasks = true;
                    ignoreMinimizedTasks = true;
                  };
                };
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "preferred://browser"
                ];
              };
            }
            "org.kde.plasma.panelspacer"
            {
              name = "com.github.tilorenz.compact_pager";
              config = {
                Appearance = {
                  displayBorder = "true";
                };
                General = {
                  forceLayout = "full";
                };
              };
            }
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
              systemTray.items = {
                hidden = [
                  "Akregator"
                  "KTailctl"
                  "org.kde.plasma.addons.katesessions"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.clipboard"
                  "org.kde.kdeconnect"
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
      ];
      powerdevil = {
        AC = {
          autoSuspend = {
            idleTimeout = 600;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 900;
          };
          turnOffDisplay = {
            idleTimeout = 300;
            idleTimeoutWhenLocked = 300;
          };
        };
        battery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 600;
          };
          dimDisplay = {
            idleTimeout = 180;
          };
          turnOffDisplay = {
            idleTimeout = 180;
            idleTimeoutWhenLocked = 300;
          };
        };
      };
      window-rules = [
        {
          description = "wezterm";
          match = {
            window-class = {
              value = "wezterm-gui";
              type = "regex";
            };
          };
          apply = {
            noborder = {
              value = true;
              apply = "force";
            };
          };
        }
      ];
    };
  };
}
