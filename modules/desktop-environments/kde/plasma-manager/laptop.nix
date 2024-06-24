{ username, ... }:
{
  imports = [ ./default.nix ];
  home-manager.users.${username} =
    { username, ... }:
    {
      programs.plasma = {
        panels = [
          {
            height = 54;
            location = "bottom";
            floating = false;
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General = {
                    icon = "/home/${username}/Downloads/nix-snowflake-white.svg";
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
