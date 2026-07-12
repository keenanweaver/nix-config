{
  configurations.nixos.nixos-laptop.module = { config, ... }: {
    home-manager.users.${config.my.user} = { config, ... }: {
      home = {
        file = {
          user-places = {
            enable = true;
            target = "${config.xdg.dataHome}/user-places.xbel";
            text = builtins.readFile ../../../assets/laptop-user-places.xbel;
          };
        };
      };
      programs.plasma = {
        input = {
          mice = [
            {
              enable = true;
              accelerationProfile = "none";
              leftHanded = false;
              middleButtonEmulation = false;
              name = "Logitech G903";
              naturalScroll = false;
              productId = "4067";
              scrollSpeed = 1;
              vendorId = "046d";
            }
          ];
          touchpads = [
            {
              enable = true;
              disableWhileTyping = true;
              leftHanded = false;
              middleButtonEmulation = false;
              name = "DELL0B6B:00 04F3:3259 Touchpad";
              naturalScroll = true;
              pointerSpeed = 0;
              productId = "3259";
              tapToClick = true;
              vendorId = "04f3";
            }
          ];
        };
        panels = [
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
                systemTray.items = {
                  hidden = [
                    "Akregator"
                    "KTailctl"
                    "org.kde.plasma.addons.katesessions"
                    "org.kde.plasma.brightness" # Night Light
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.clipboard"
                    "org.kde.kdeconnect"
                    "indicator-solaar"
                    "xdg-desktop-portal-kde" # Portal
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
            apply = {
              noborder = {
                apply = "force";
                value = true;
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
        ];
      };
    };
  };
}
