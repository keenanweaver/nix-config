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
      /*       {
        name = "org.kde.plasma.volume";
        config = {
          General = {
            showVirtualDevices = "true";
          };
        };
      } */
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
            stationID = "KNEOMAHA1072";
          };
          Units = {
            unitsChoice = "1";
          };
        };
      }
      "org.kde.plasma.marginsseparator"
      "org.kde.plasma.marginsseparator"
      "org.kde.plasma.systemtray"
      "org.kde.plasma.digitalclock"
      "org.kde.plasma.showdesktop"
    ];
    screen = screenId;
  };
in
{
  imports = [
    ./default.nix
  ];
  home-manager.users.${username} = { username, ... }: {
    programs.plasma = {
      configFile = {
        khotkeysrc = {
          "Data_6"."Comment".value = "PrintScreen Clipboard Rectangular\n\nhttps://forum.kde.org/viewtopic.php?t=140137#p430092";
          "Data_6"."Enabled".value = true;
          "Data_6"."Name".value = "Area screenshot";
          "Data_6"."Type".value = "SIMPLE_ACTION_DATA";
          "Data_6Actions"."ActionsCount".value = 1;
          "Data_6Actions0"."CommandURL".value = "spectacle -bcr";
          "Data_6Actions0"."Type".value = "COMMAND_URL";
          "Data_6Conditions"."Comment".value = "";
          "Data_6Conditions"."ConditionsCount".value = 0;
          "Data_6Triggers"."Comment".value = "Simple_action";
          "Data_6Triggers"."TriggersCount".value = 1;
          "Data_6Triggers0"."Key".value = "Meta+Shift+Print";
          "Data_6Triggers0"."Type".value = "SHORTCUT";
          "Data_6Triggers0"."Uuid".value = "{343ea740-cb9f-4be8-95b3-aa44840995f3}";
          "Data_7"."Comment".value = "Comment";
          "Data_7"."DataCount".value = 1;
          "Data_7"."Enabled".value = true;
          "Data_7"."Name".value = "GPU-Screen-Recorder";
          "Data_7"."SystemGroup".value = 0;
          "Data_7"."Type".value = "ACTION_DATA_GROUP";
          "Data_7Conditions"."Comment".value = "";
          "Data_7Conditions"."ConditionsCount".value = 0;
          "Data_7_1"."Comment".value = "Save GPU Screen Recorder replay";
          "Data_7_1"."Enabled".value = true;
          "Data_7_1"."Name".value = "Save replay";
          "Data_7_1"."Type".value = "SIMPLE_ACTION_DATA";
          "Data_7_1Actions"."ActionsCount".value = 1;
          "Data_7_1Actions0"."CommandURL".value = "/home/${username}/.local/bin/gsr-save-replay.sh";
          "Data_7_1Actions0"."Type".value = "COMMAND_URL";
          "Data_7_1Conditions"."Comment".value = "";
          "Data_7_1Conditions"."ConditionsCount".value = 0;
          "Data_7_1Triggers"."Comment".value = "Simple_action";
          "Data_7_1Triggers"."TriggersCount".value = 1;
          "Data_7_1Triggers0"."Key".value = "Meta+Ctrl+|";
          "Data_7_1Triggers0"."Type".value = "SHORTCUT";
          "Data_7_1Triggers0"."Uuid".value = "{5b656294-4568-48d1-8863-e5df66354f30}";
        };
      };
      hotkeys = {
        commands = {
          "GSR-Save-Replay" = {
            name = "Save GSR Replay";
            key = "Meta+Ctrl+|";
            command = "/home/${username}/.local/bin/gsr-save-replay.sh";
          };
        };
      };
      panels = [
        (primaryPanel 0)
        (secondaryPanel 1)
      ];
      shortcuts = {
        khotkeys = {
          "{343ea740-cb9f-4be8-95b3-aa44840995f3}" = "Meta+Shift+Print";
          "{5b656294-4568-48d1-8863-e5df66354f30}" = "Meta+Ctrl+|";
        };
      };
    };
  };
}
