{
  configurations.nixos.nixos-htpc.module = { config, ... }: {
    home-manager.users.${config.my.user} = { config, ... }: {
      home = {
        file = {
          user-places = {
            enable = true;
            target = "${config.xdg.dataHome}/user-places.xbel";
            text = builtins.readFile ../../../assets/htpc-user-places.xbel;
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
              name = "Shenzhen Rapoo Technology Co., Ltd. Rapoo Gaming Device";
              naturalScroll = false;
              productId = "1211";
              scrollSpeed = 1;
              vendorId = "24ae";
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
                kickerdash = {
                  icon = builtins.path {
                    path = ../../../assets/theming/nix-catppuccin-logo.png;
                  };
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
        ];
      };
    };
  };
}
