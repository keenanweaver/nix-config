{ username, ... }:
let
  primaryPanel = screenId: {
    height = 54;
    location = "bottom";
    floating = false;
    widgets = [
      {
        name = "org.kde.plasma.kickoff";
        config = {
          General = {
            icon = "nix-snowflake-white";
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
      #"org.kde.plasma.systemtray"
      {
        name = "org.kde.plasma.systemtray";
        config = {
          General = {
            showVirtualDevices = "true";
          };
        };
      }
      /*
        {
          name = "org.kde.plasma.volume";
          config = {
            General = {
              showVirtualDevices = "true";
            };
          };
        }
      */
      "org.kde.plasma.digitalclock"
      "org.kde.plasma.showdesktop"
    ];
    screen = screenId;
  };
  secondaryPanel = screenId: {
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
              "applications:Alacritty.desktop"
              "applications:org.wezfurlong.wezterm.desktop"
              "applications:org.signal.Signal.desktop"
              "applications:xyz.armcord.ArmCord.desktop"
              "applications:info.mumble.Mumble.desktop"
              "applications:qobuz.desktop"
              "applications:org.strawberrymusicplayer.strawberry.desktop"
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
      #"org.kde.plasma.systemtray"
      "org.kde.plasma.digitalclock"
      "org.kde.plasma.showdesktop"
    ];
    screen = screenId;
  };
in
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
        panels = [
          (primaryPanel 0)
          (secondaryPanel 1)
        ];
      };
    };
}
