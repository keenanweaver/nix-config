{ username, dotfiles, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} = {
    programs.plasma = {
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
                icon = "${dotfiles}/Pictures/nix-snowflake-white.svg";
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
                  "opensnitch-ui"
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
    };
  };
}
