{ username, pkgs, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} = {
    programs.plasma = {
      #extraWidgets = [ ];
      input = {
        mice = [
          {
            enable = true;
            name = "Logitech G502 X LS";
            vendorId = "046d";
            productId = "409f";
            leftHanded = false;
            middleButtonEmulation = false;
            accelerationProfile = "none";
            naturalScroll = false;
            scrollSpeed = 1;
          }
        ];
      };
      panels = [
        # Primary
        {
          height = 54;
          location = "bottom";
          floating = false;
          screen = 0;
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
              name = "org.kde.plasma.pager";
              config = {
                General = {
                  displayedText = "Number";
                  wrapPage = true;
                };
              };
            }
            {
              systemTray = {
                items = {
                  configs = {
                    "org.kde.plasma.volume".config = {
                      General = {
                        "showVirtualDevices" = true;
                      };
                    };
                  };
                  hidden = [
                    "opensnitch-ui"
                    "org.kde.plasma.addons.katesessions"
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.clipboard"
                    "org.kde.kdeconnect"
                    "indicator-solaar"
                    "tray-id" # Sunshine
                    #"chrome_status_icon_1" # Armcord
                  ];
                };
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
        }
        # Secondary
        {
          height = 54;
          location = "bottom";
          floating = false;
          screen = 1;
          widgets = [
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
                  "applications:org.wezfurlong.wezterm.desktop"
                  "applications:org.codeberg.dnkl.foot.desktop"
                  "applications:org.signal.Signal.desktop"
                  "applications:xyz.armcord.ArmCord.desktop"
                  "applications:info.mumble.Mumble.desktop"
                  "applications:qobuz.desktop"
                  "applications:foobar2000.desktop"
                  "applications:org.fooyin.fooyin.desktop"
                  "applications:org.kde.neochat.desktop"
                  "applications:org.kde.tokodon.desktop"
                ];
              };
            }
            "org.kde.plasma.panelspacer"
            {
              name = "org.kde.plasma.pager";
              config = {
                General = {
                  displayedText = "Number";
                  wrapPage = true;
                };
              };
            }
            {
              name = "com.github.k-donn.plasmoid-wunderground";
              config = {
                Station = {
                  refreshPeriod = "900";
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
        }
      ];
      powerdevil.AC = {
        autoSuspend.action = "nothing";
        turnOffDisplay = {
          idleTimeout = 900;
        };
      };
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
