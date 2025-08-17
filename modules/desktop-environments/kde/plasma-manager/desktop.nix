{ username, pkgs, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      home.file = {
        user-places = {
          enable = true;
          text = builtins.readFile ./desktop-user-places.xbel;
          target = "${config.xdg.dataHome}/user-places.xbel";
        };
      };
      programs.plasma = {
        input = {
          mice = [
            {
              enable = true;
              name = "Logitech G502 X LS";
              vendorId = "046d";
              productId = "409f";
              leftHanded = false;
              middleButtonEmulation = false;
              acceleration = 0;
              accelerationProfile = "none";
              naturalScroll = false;
              scrollSpeed = 1;
            }
            {
              enable = true;
              name = "Logitech USB Receiver";
              vendorId = "046d";
              productId = "c547";
              acceleration = 0;
              accelerationProfile = "none";
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
              {
                panelSpacer = {
                  expanding = true;
                };
              }
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
                      "Akregator"
                      "KTailctl"
                      "MoonDeckBuddy"
                      "com.core447.StreamController.TrayIcon"
                      "org.kde.plasma.addons.katesessions"
                      "org.kde.plasma.brightness" # Night Light
                      "org.kde.plasma.networkmanagement"
                      "org.kde.plasma.clipboard"
                      "org.kde.kdeconnect"
                      "indicator-solaar"
                      "tray-id" # Sunshine
                      "xdg-desktop-portal-kde" # Portal
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
                    "applications:vesktop.desktop"
                    "applications:signal.desktop"
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
                    refreshPeriod = "900";
                    stationID = "KNEOMAHA1247";
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
            description = "vesktop";
            match = {
              window-class = {
                value = "electron vesktop";
                type = "exact";
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
            description = "dosbox";
            match = {
              window-class = {
                value = "dosbox";
                type = "regex";
              };
            };
            apply = {
              adaptivesync = {
                value = false;
                apply = "force";
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
            description = "icon: azahar";
            match = {
              window-class = {
                value = "azahar";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "org.azahar_emu.Azahar";
              apply = "force";
            };
          }
          {
            description = "icon: doomseeker";
            match = {
              window-class = {
                value = "doomseeker";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "org.drdteam.Doomseeker";
              apply = "force";
            };
          }
          {
            description = "icon: faugus";
            match = {
              window-class = {
                value = "faugus";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "faugus-launcher";
              apply = "force";
            };
          }
          {
            description = "icon: heroic";
            match = {
              window-class = {
                value = "heroic";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "com.heroicgameslauncher.hgl";
              apply = "force";
            };
          }
          {
            description = "icon: melonDS";
            match = {
              window-class = {
                value = "melonDS";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "net.kuribo64.melonDS";
              apply = "force";
            };
          }
          {
            description = "icon: pcsx2";
            match = {
              window-class = {
                value = "pcsx2";
                type = "regex";
              };
            };
            apply = {
              desktopfile = "net.pcsx2.PCSX2";
              apply = "force";
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
                value = "Desktop_2"; # Social desktop
              };
              position = {
                value = "0,0";
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
            description = "obs";
            match = {
              window-class = {
                value = "obs";
                type = "exact";
              };
            };
            apply = {
              position = {
                value = "1026,646";
              };
              screen = {
                value = 1;
                apply = "initially";
              };
              size = {
                value = "1534,740";
                apply = "initially";
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
                value = "Desktop_2"; # Social desktop
              };
              position = {
                value = "1287,0";
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
                apply = "initially";
              };
              position = {
                value = "0,646";
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
            description = "spectacle";
            match = {
              window-class = {
                value = "spectacle";
                type = "regex";
              };
            };
            apply = {
              adaptivesync = {
                value = false;
                apply = "force";
              };
            };
          }
        ];
      };
    };
}
