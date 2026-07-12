{
  configurations.nixos.nixos-desktop.module = { config, ... }: {
    home-manager.users.${config.my.user} = { config, ... }: {
      home = {
        file = {
          user-places = {
            enable = true;
            target = "${config.xdg.dataHome}/user-places.xbel";
            text = builtins.readFile ../../../assets/desktop-user-places.xbel;
          };
        };
      };
      programs.plasma = {
        input = {
          mice = [
            {
              enable = true;
              acceleration = 0;
              accelerationProfile = "none";
              leftHanded = false;
              middleButtonEmulation = false;
              name = "Logitech G502 X LS";
              naturalScroll = false;
              productId = "409f";
              scrollSpeed = 1;
              vendorId = "046d";
            }
            {
              enable = true;
              acceleration = 0;
              accelerationProfile = "none";
              name = "Logitech USB Receiver";
              productId = "c547";
              vendorId = "046d";
            }
          ];
        };
        panels = [
          # Primary
          {
            floating = false;
            height = 38;
            location = "bottom";
            screen = 0;
            widgets = [
              {
                kickoff =
                  let
                    start-icon = builtins.path {
                      path = ../../../assets/theming/nix-catppuccin-logo.png;
                    };
                  in
                  {
                    applicationsDisplayMode = "list";
                    compactDisplayStyle = true;
                    favoritesDisplayMode = "grid";
                    icon = start-icon;
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
                    rows.multirowView = "never";
                    showTooltips = true;
                  };
                  behavior = {
                    grouping = {
                      clickAction = "cycle";
                      method = "byProgramName";
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
                      ignoreMinimizedTasks = true;
                      switchBetweenTasks = true;
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
                config = {
                  Appearance = {
                    displayBorder = "true";
                  };
                  General = {
                    forceLayout = "full";
                  };
                };
                name = "com.github.tilorenz.compact_pager";
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
                      "CoolerControl"
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
                      "chrome_status_icon_1" # Vesktop
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
            floating = false;
            height = 38;
            location = "bottom";
            screen = 1;
            widgets = [
              {
                iconTasks = {
                  appearance = {
                    fill = true;
                    highlightWindows = true;
                    indicateAudioStreams = true;
                    rows.multirowView = "never";
                    showTooltips = true;
                  };
                  behavior = {
                    grouping = {
                      clickAction = "cycle";
                      method = "byProgramName";
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
                      ignoreMinimizedTasks = true;
                      switchBetweenTasks = true;
                    };
                  };
                  launchers = [
                    "applications:org.wezfurlong.wezterm.desktop"
                    "applications:vesktop.desktop"
                    "applications:fluxer-desktop-canary.desktop"
                    #"applications:org.squidowl.halloy.desktop"
                    "applications:signal.desktop"
                    "applications:info.mumble.Mumble.desktop"
                    "applications:QBZ.desktop"
                    #"applications:foobar2000.desktop"
                    "applications:org.fooyin.fooyin.desktop"
                    "applications:org.kde.neochat.desktop"
                    "applications:org.kde.tokodon.desktop"
                  ];
                };
              }
              "org.kde.plasma.panelspacer"
              {
                config = {
                  Appearance = {
                    displayBorder = "true";
                  };
                  General = {
                    forceLayout = "full";
                  };
                };
                name = "com.github.tilorenz.compact_pager";
              }
              {
                config = {
                  Station = {
                    refreshPeriod = "900";
                    stationID = "KNEOMAHA544";
                  };
                  Units = {
                    unitsChoice = "1";
                  };
                };
                name = "com.github.k-donn.plasmoid-wunderground";
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
            apply = {
              ignoregeometry = {
                value = true;
              };
              screen = {
                value = 0;
              };
            };
            description = "Move portal windows to primary screen";
            match = {
              window-class = {
                match-whole = false;
                type = "exact";
                value = "xdg-desktop-portal-kde";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "0,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "1026,662";
              };
            };
            description = "vesktop";
            match = {
              window-class = {
                type = "exact";
                value = "electron vesktop";
              };
            };
          }
          {
            apply = {
              desktopfile = "fluxer-desktop";
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "0,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "1026,662";
              };
            };
            description = "fluxer";
            match = {
              window-class = {
                type = "substring";
                value = "fluxer";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "0,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "1026,646";
              };
            };
            description = "halloy";
            match = {
              window-class = {
                type = "exact";
                value = "halloy org.squidowl.halloy";
              };
            };
          }
          {
            apply = {
              adaptivesync = {
                apply = "force";
                value = false;
              };
            };
            description = "dosbox";
            match = {
              window-class = {
                type = "regex";
                value = "dosbox";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                apply = "force";
                value = "0,646";
              };
              screen = {
                value = 1;
              };
              size = {
                value = "1026,740";
              };
            };
            description = "foobar2000";
            match = {
              window-class = {
                type = "regex";
                value = "foobar2000";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,662";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "1534,741";
              };
            };
            description = "fooyin";
            match = {
              window-class = {
                type = "regex";
                value = "fooyin";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,662";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "1534,741";
              };
            };
            description = "qbz";
            match = {
              window-class = {
                type = "exact";
                value = "qbz";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "org.azahar_emu.Azahar";
            };
            description = "icon: azahar";
            match = {
              window-class = {
                type = "regex";
                value = "azahar";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "org.drdteam.Doomseeker";
            };
            description = "icon: doomseeker";
            match = {
              window-class = {
                type = "regex";
                value = "doomseeker";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "faugus-launcher";
            };
            description = "icon: faugus";
            match = {
              window-class = {
                type = "regex";
                value = "faugus";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "com.heroicgameslauncher.hgl";
            };
            description = "icon: heroic";
            match = {
              window-class = {
                type = "regex";
                value = "heroic";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "net.kuribo64.melonDS";
            };
            description = "icon: melonDS";
            match = {
              window-class = {
                type = "regex";
                value = "melonDS";
              };
            };
          }
          {
            apply = {
              apply = "force";
              desktopfile = "net.pcsx2.PCSX2";
            };
            description = "icon: pcsx2";
            match = {
              window-class = {
                type = "regex";
                value = "pcsx2";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1723,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "611,662";
              };
            };
            description = "mumble";
            match = {
              window-class = {
                type = "regex";
                value = "mumble";
              };
              window-types = [ "normal" ];
            };
          }
          {
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
            description = "neochat";
            match = {
              window-class = {
                match-whole = false;
                type = "regex";
                value = "neochat";
              };
            };
          }
          {
            apply = {
              position = {
                value = "1026,646";
              };
              screen = {
                apply = "initially";
                value = 1;
              };
              size = {
                apply = "initially";
                value = "1534,740";
              };
            };
            description = "obs";
            match = {
              window-class = {
                type = "exact";
                value = "obs";
              };
            };
          }
          {
            apply = {
              ignoregeometry = {
                value = true;
              };
              position = {
                value = "1026,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
              size = {
                value = "697,662";
              };
            };
            description = "signal";
            match = {
              window-class = {
                type = "regex";
                value = "signal";
              };
            };
          }
          {
            apply = {
              position = {
                apply = "force";
                value = "2334,0";
              };
              screen = {
                apply = "force";
                value = 1;
              };
            };
            description = "steam friends list";
            match = {
              title = {
                type = "exact";
                value = "Friends list";
              };
              window-class = {
                type = "exact";
                value = "steam";
              };
            };
          }
          {
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
            description = "tokodon";
            match = {
              window-class = {
                match-whole = false;
                type = "regex";
                value = "tokodon";
              };
            };
          }
          {
            apply = {
              noborder = {
                apply = "initially";
                value = true;
              };
              position = {
                value = "0,662";
              };
              screen = {
                value = 1;
              };
              size = {
                value = "1026,740";
              };
            };
            description = "wezterm";
            match = {
              window-class = {
                type = "regex";
                value = "wezterm-gui";
              };
            };
          }
          {
            apply = {
              adaptivesync = {
                apply = "force";
                value = false;
              };
            };
            description = "spectacle";
            match = {
              window-class = {
                type = "regex";
                value = "spectacle";
              };
            };
          }
        ];
      };
    };
  };
}
