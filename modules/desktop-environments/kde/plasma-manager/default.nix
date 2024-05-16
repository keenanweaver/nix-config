{ username, ... }:
{
  home-manager.users.${username} =
    { username, pkgs, ... }:
    {
      programs.kate = {
        lsp.customServers = {
          css = {
            command = [
              "vscode-css-language-server"
              "--stdio"
            ];
            url = "https://github.com/Microsoft/vscode/tree/main/extensions/css-language-features/server";
            highlightingModeRegex = "^CSS$";
          };
          html = {
            command = [
              "vscode-html-language-server"
              "--stdio"
            ];
            url = "https://github.com/Microsoft/vscode/tree/main/extensions/html-language-features/server";
            highlightingModeRegex = "^HTML$";
          };
          json = {
            command = [
              "vscode-json-language-server"
              "--stdio"
            ];
            url = "https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server";
            highlightingModeRegex = "^JSON$";
          };
          markdown = {
            command = [ "marksman" ];
            url = "https://github.com/artempyanykh/marksman";
            highlightingModeRegex = "^Markdown$";
          };
          nix = {
            command = [ "nixd" ];
            url = "https://github.com/nix-community/nixd";
            highlightingModeRegex = "^Nix$";
          };
          python = {
            command = [ "ruff-lsp" ];
            url = "https://github.com/astral-sh/ruff-lsp";
            highlightingModeRegex = "^Python$";
          };
          terraform = {
            rootIndicationFileNames = [
              "*.tf"
              "*.tfvars"
            ];
          };
        };
      };
      programs.konsole = {
        enable = true;
        defaultProfile = "${username}";
        profiles = {
          "${username}" = {
            command = "${pkgs.zsh}/bin/zsh";
          };
        };
      };
      programs.plasma = {
        enable = true;
        #overrideConfig = true;
        configFile = {
          "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
          "kwinrc"."Desktops"."Number" = 2;
          "systemsettingsrc"."KFileDialog Settings"."detailViewIconSize" = 16;
          "systemsettingsrc"."systemsettings_sidebar_mode"."HighlightNonDefaultSettings" = true;
          dolphinrc = {
            "Desktop Entry"."DefaultProfile" = "${username}.profile";
            "DetailsMode"."HighlightEntireRow" = false;
            "DetailsMode"."PreviewSize" = 32;
            "DetailsMode"."SidePadding" = 0;
            "General"."FilterBar" = true;
            "General"."GlobalViewProps" = false;
            "General"."RememberOpenedTabs" = false;
            "General"."ShowFullPath" = true;
            "General"."ShowFullPathInTitlebar" = true;
            "General"."SplitView" = true;
            "General"."UseTabForSwitchingSplitView" = true;
            "IconsMode"."PreviewSize" = 112;
            "KFileDialog Settings"."Places Icons Auto-resize" = false;
            "KFileDialog Settings"."Places Icons Static Size" = 32;
            "KFileDialog Settings"."detailViewIconSize" = 16;
            "MainWindow.Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
            "PlacesPanel"."IconSize" = 32;
            "Search"."Location" = "Everywhere";
            "Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
          };
          kdeglobals = {
            "General"."AllowKDEAppsToRememberWindowPositions" = true;
            "General"."BrowserApplication" = "one.ablaze.floorp.desktop";
            "KDE"."AnimationDurationFactor" = 0.5;
            "KDE"."ShowDeleteCommand" = true;
            "KFileDialog Settings"."Allow Expansion" = true;
            "KFileDialog Settings"."Automatically select filename extension" = true;
            "KFileDialog Settings"."Breadcrumb Navigation" = false;
            "KFileDialog Settings"."Decoration position" = 2;
            "KFileDialog Settings"."LocationCombo Completionmode" = 5;
            "KFileDialog Settings"."PathCombo Completionmode" = 5;
            "KFileDialog Settings"."Show Bookmarks" = true;
            "KFileDialog Settings"."Show Full Path" = false;
            "KFileDialog Settings"."Show Inline Previews" = false;
            "KFileDialog Settings"."Show Preview" = false;
            "KFileDialog Settings"."Show Speedbar" = true;
            "KFileDialog Settings"."Show hidden files" = true;
            "KFileDialog Settings"."Sort by" = "Name";
            "KFileDialog Settings"."Sort directories first" = true;
            "KFileDialog Settings"."Sort hidden files last" = true;
            "KFileDialog Settings"."Sort reversed" = false;
            "KFileDialog Settings"."Speedbar Width" = 133;
            "KFileDialog Settings"."View Style" = "DetailTree";
            "KScreen"."XwaylandClientsScale" = false; # Steam workaround
          };
          kwinrc = {
            "Effect-blur"."BlurStrength" = 12;
            "Effect-windowview"."BorderActivateAll" = 9;
            "NightColor"."Active" = true;
            "NightColor"."MorningBeginFixed" = 800;
            "NightColor"."NightTemperature" = 3300;
            "Plugins"."MoveWindowToCenterEnabled" = true;
            "Plugins"."alwaysopenonprimaryscreen" = "Enabled";
            "Plugins"."blurEnabled" = true;
            "Plugins"."glideEnabled" = true;
            "Plugins"."kwin4_effect_fadingpopupsEnabled" = false;
            "Plugins"."kwin4_effect_fadingpopups_kineticEnabled" = true;
            "Plugins"."kwin4_effect_maximizeEnabled" = false;
            "Plugins"."kwin4_effect_maximize_kineticEnabled" = true;
            "Plugins"."kwin4_effect_minimize_kineticEnabled" = true;
            "Plugins"."kwin4_effect_open_close_kineticEnabled" = true;
            "Plugins"."kwin4_effect_scaleEnabled" = false;
            "Plugins"."kwin4_effect_squashEnabled" = false;
            "Plugins"."kwin4_effect_translucencyEnabled" = true;
            "Plugins"."restoreToScreenEnabled" = true;
            "Plugins"."scaleEnabled" = false;
            "Plugins"."translucencyEnabled" = true;
            "Plugins"."wobblywindowsEnabled" = true;
            #"Script-alwaysopenonprimaryscreen"."classList" = "steam\nsteamwebhelper\nmumble\ninfo.mumble.Mumble\nstrawberry\nobs\narmcord\nsignal";
            "Script-forceblur"."blurExceptMatching" = true;
            "Script-forceblur"."blurMatching" = false;
            "TabBox"."LayoutName" = "thumbnail_grid";
            "TabBoxAlternative"."LayoutName" = "thumbnails";
            "Windows"."ActiveMouseScreen" = false;
            "Windows"."Placement" = "Centered";
          };
          kwinrulesrc = {
            "06034a13-968b-4c69-b80f-47e7d2eca419"."Description" = "Application settings for foobar2000.exe";
            "06034a13-968b-4c69-b80f-47e7d2eca419"."clientmachine" = "localhost";
            "06034a13-968b-4c69-b80f-47e7d2eca419"."ignoregeometry" = true;
            "06034a13-968b-4c69-b80f-47e7d2eca419"."ignoregeometryrule" = 2;
            "06034a13-968b-4c69-b80f-47e7d2eca419"."position" = "0,647";
            "06034a13-968b-4c69-b80f-47e7d2eca419"."positionrule" = 2;
            "06034a13-968b-4c69-b80f-47e7d2eca419"."screen" = 1;
            "06034a13-968b-4c69-b80f-47e7d2eca419"."screenrule" = 2;
            "06034a13-968b-4c69-b80f-47e7d2eca419"."wmclass" = "foobar2000.exe";
            "06034a13-968b-4c69-b80f-47e7d2eca419"."wmclassmatch" = 1;
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."Description" = "Application settings for org.wezfurlong.wezterm";
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."clientmachine" = "localhost";
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."maximizehoriz" = true;
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."maximizehorizrule" = 3;
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."maximizevert" = true;
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."maximizevertrule" = 3;
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."wmclass" = "org.wezfurlong.wezterm";
            "07f1dba2-28d8-4910-9492-91d374fcbec1"."wmclassmatch" = 1;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."Description" = "qobuz (wayland)";
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."clientmachine" = "localhost";
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."ignoregeometry" = true;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."ignoregeometryrule" = 3;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."position" = "1026,646";
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."positionrule" = 3;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."screen" = 1;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."screenrule" = 2;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."size" = "1534,740";
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."sizerule" = 3;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."wmclass" = "qobuz";
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."wmclasscomplete" = true;
            "0b78bcee-f81e-4996-b6ee-22d3b287760d"."wmclassmatch" = 3;
            "1"."Description" = "codium (wayland)";
            "1"."clientmachine" = "localhost";
            "1"."ignoregeometry" = true;
            "1"."ignoregeometryrule" = 3;
            "1"."position" = "1026,646";
            "1"."screen" = 1;
            "1"."screenrule" = 3;
            "1"."size" = "1534,741";
            "1"."wmclass" = "codium";
            "1"."wmclasscomplete" = true;
            "1"."wmclassmatch" = 3;
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."Description" = "Application settings for foobar2000.exe";
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."clientmachine" = "localhost";
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."position" = "0,644";
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."positionrule" = 2;
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."screen" = 1;
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."screenrule" = 2;
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."wmclass" = "foobar2000.exe";
            "188716e8-75b6-4d1c-b0c7-3088fdb41b5a"."wmclassmatch" = 1;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."Description" = "strawberry (wayland)";
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."clientmachine" = "localhost";
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."ignoregeometry" = true;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."ignoregeometryrule" = 3;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."position" = "1026,646";
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."positionrule" = 3;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."screen" = 1;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."screenrule" = 2;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."size" = "1534,741";
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."sizerule" = 3;
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."wmclass" = "strawberry";
            "18c470d0-b4ea-4fc6-9652-a5e04614e7bd"."wmclassmatch" = 3;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."Description" = "Application settings for signal";
            "1ae46008-4852-415b-8405-72c7518c2cd1"."clientmachine" = "localhost";
            "1ae46008-4852-415b-8405-72c7518c2cd1"."ignoregeometry" = true;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."ignoregeometryrule" = 2;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."position" = "1026,0";
            "1ae46008-4852-415b-8405-72c7518c2cd1"."positionrule" = 2;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."screen" = 1;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."screenrule" = 2;
            "1ae46008-4852-415b-8405-72c7518c2cd1"."wmclass" = "signal";
            "1ae46008-4852-415b-8405-72c7518c2cd1"."wmclassmatch" = 1;
            "1b3c8662-3545-4efe-af15-48481e5fce90"."Description" = "Application settings for org.wezfurlong.wezterm";
            "1b3c8662-3545-4efe-af15-48481e5fce90"."clientmachine" = "localhost";
            "1b3c8662-3545-4efe-af15-48481e5fce90"."types" = 1;
            "1b3c8662-3545-4efe-af15-48481e5fce90"."wmclass" = "wezterm";
            "1b3c8662-3545-4efe-af15-48481e5fce90"."wmclassmatch" = 3;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."Description" = "fooyin (wayland)";
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."clientmachine" = "localhost";
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."ignoregeometry" = true;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."ignoregeometryrule" = 3;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."position" = "1026,646";
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."positionrule" = 3;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."screen" = 1;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."screenrule" = 2;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."size" = "1534,741";
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."sizerule" = 3;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."wmclass" = "fooyin";
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."wmclasscomplete" = true;
            "1b90668e-1ada-4c5b-bf80-d1b2bd3ce481"."wmclassmatch" = 3;
            "2"."Description" = "strawberry (wayland)";
            "2"."clientmachine" = "localhost";
            "2"."ignoregeometry" = true;
            "2"."ignoregeometryrule" = 3;
            "2"."position" = "1026,646";
            "2"."positionrule" = 3;
            "2"."screen" = 1;
            "2"."screenrule" = 2;
            "2"."size" = "1534,741";
            "2"."sizerule" = 3;
            "2"."wmclass" = "strawberry";
            "2"."wmclasscomplete" = true;
            "2"."wmclassmatch" = 3;
            "28925769-d221-4bf5-b0f7-6ded9da29489"."Description" = "Move portal windows to primary screen";
            "28925769-d221-4bf5-b0f7-6ded9da29489"."ignoregeometry" = true;
            "28925769-d221-4bf5-b0f7-6ded9da29489"."ignoregeometryrule" = 3;
            "28925769-d221-4bf5-b0f7-6ded9da29489"."screenrule" = 3;
            "28925769-d221-4bf5-b0f7-6ded9da29489"."wmclass" = "xdg-desktop-portal-kde";
            "28925769-d221-4bf5-b0f7-6ded9da29489"."wmclassmatch" = 1;
            "2ab981be-f620-4442-97e0-b1329e355522"."Description" = "Application settings for strawberry";
            "2ab981be-f620-4442-97e0-b1329e355522"."clientmachine" = "localhost";
            "2ab981be-f620-4442-97e0-b1329e355522"."position" = "1011,644";
            "2ab981be-f620-4442-97e0-b1329e355522"."positionrule" = 2;
            "2ab981be-f620-4442-97e0-b1329e355522"."screen" = 1;
            "2ab981be-f620-4442-97e0-b1329e355522"."screenrule" = 2;
            "2ab981be-f620-4442-97e0-b1329e355522"."wmclass" = "strawberry";
            "2ab981be-f620-4442-97e0-b1329e355522"."wmclassmatch" = 1;
            "3"."Description" = "obs (wayland)";
            "3"."clientmachine" = "localhost";
            "3"."ignoregeometry" = true;
            "3"."ignoregeometryrule" = 3;
            "3"."position" = "1026,646";
            "3"."positionrule" = 3;
            "3"."screen" = 1;
            "3"."screenrule" = 2;
            "3"."size" = "1534,740";
            "3"."sizerule" = 3;
            "3"."wmclass" = "obs";
            "3"."wmclasscomplete" = true;
            "3"."wmclassmatch" = 3;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."Description" = "Steam friends list";
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."clientmachine" = "localhost";
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."position" = "2334,0";
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."positionrule" = 2;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."screen" = 1;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."screenrule" = 2;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."title" = "Friends List";
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."titlematch" = 1;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."types" = 1;
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."wmclass" = "steam";
            "3c7327ff-b19b-4c58-82f2-bef7b7512ffa"."wmclassmatch" = 1;
            "4"."Description" = "qobuz (wayland)";
            "4"."clientmachine" = "localhost";
            "4"."ignoregeometry" = true;
            "4"."ignoregeometryrule" = 3;
            "4"."position" = "1026,646";
            "4"."positionrule" = 3;
            "4"."screen" = 1;
            "4"."screenrule" = 2;
            "4"."size" = "1534,740";
            "4"."sizerule" = 3;
            "4"."wmclass" = "qobuz";
            "4"."wmclasscomplete" = true;
            "4"."wmclassmatch" = 3;
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."Description" = "codium (wayland)";
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."ignoregeometry" = true;
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."ignoregeometryrule" = 3;
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."screenrule" = 3;
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."wmclass" = "codium";
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."wmclasscomplete" = true;
            "4647e605-1274-47a6-91e2-b33b3d7ba104"."wmclassmatch" = 3;
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."Description" = "Application settings for signal";
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."clientmachine" = "localhost";
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."ignoregeometryrule" = 3;
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."position" = "1026,0";
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."positionrule" = 3;
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."screen" = 1;
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."screenrule" = 3;
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."wmclass" = "signal";
            "489ee260-5240-437f-a4d8-20f528bfdcd3"."wmclassmatch" = 1;
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."Description" = "Application settings for armcord";
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."clientmachine" = "localhost";
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."position" = "0,0";
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."positionrule" = 2;
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."screen" = 1;
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."screenrule" = 2;
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."wmclass" = "armcord";
            "4d83c749-4026-4cbc-9f2a-ea5d18b831d4"."wmclassmatch" = 1;
            "5"."Description" = "foobar2000 (wayland)";
            "5"."clientmachine" = "localhost";
            "5"."ignoregeometry" = true;
            "5"."ignoregeometryrule" = 3;
            "5"."position" = "0,646";
            "5"."positionrule" = 2;
            "5"."screen" = 1;
            "5"."screenrule" = 3;
            "5"."size" = "1026,740";
            "5"."sizerule" = 3;
            "5"."wmclass" = "foobar2000";
            "5"."wmclasscomplete" = true;
            "5"."wmclassmatch" = 3;
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."Description" = "Application settings for info.mumble.Mumble";
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."position" = "1707,0";
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."positionrule" = 2;
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."screen" = 1;
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."screenrule" = 2;
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."wmclass" = "sinfo.mumble.Mumble";
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."wmclasscomplete" = true;
            "589a15f8-5920-4d72-971d-6d9a0684afdc"."wmclassmatch" = 1;
            "5a310dc1-45df-40dc-9889-1a054acc528e"."Description" = "Application settings for org.wezfurlong.wezterm";
            "5a310dc1-45df-40dc-9889-1a054acc528e"."clientmachine" = "localhost";
            "5a310dc1-45df-40dc-9889-1a054acc528e"."screen" = 1;
            "5a310dc1-45df-40dc-9889-1a054acc528e"."screenrule" = 4;
            "5a310dc1-45df-40dc-9889-1a054acc528e"."wmclass" = "org.wezfurlong.wezterm";
            "5a310dc1-45df-40dc-9889-1a054acc528e"."wmclassmatch" = 1;
            "6"."Description" = "armcord (wayland)";
            "6"."clientmachine" = "localhost";
            "6"."ignoregeometry" = true;
            "6"."ignoregeometryrule" = 3;
            "6"."position" = "0,0";
            "6"."positionrule" = 3;
            "6"."screen" = 1;
            "6"."screenrule" = 2;
            "6"."size" = "1026,646";
            "6"."sizerule" = 3;
            "6"."wmclass" = "armcord";
            "6"."wmclasscomplete" = true;
            "6"."wmclassmatch" = 3;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."Description" = "Application settings for foobar2000.exe";
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."clientmachine" = "localhost";
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."ignoregeometry" = true;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."ignoregeometryrule" = 3;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."position" = "0,646";
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."positionrule" = 2;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."screen" = 1;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."screenrule" = 3;
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."wmclass" = "foobar2000.exe";
            "6520f6c1-3ea6-4c36-b641-11f3bb3a881b"."wmclassmatch" = 1;
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."Description" = "Application settings for armcord";
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."clientmachine" = "localhost";
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."screen" = 1;
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."screenrule" = 2;
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."size" = "1011,651";
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."sizerule" = 3;
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."wmclass" = "armcord";
            "6ca475ab-b3e8-4d04-9f9a-9ce3c0e7025f"."wmclassmatch" = 1;
            "7"."Description" = "signal (wayland)";
            "7"."clientmachine" = "localhost";
            "7"."ignoregeometry" = true;
            "7"."ignoregeometryrule" = 3;
            "7"."position" = "1026,0";
            "7"."positionrule" = 3;
            "7"."screen" = 1;
            "7"."screenrule" = 2;
            "7"."size" = "697,646";
            "7"."sizerule" = 3;
            "7"."wmclass" = "signal";
            "7"."wmclasscomplete" = true;
            "7"."wmclassmatch" = 3;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."Description" = "Window settings for steamwebhelper";
            "7843300b-b1dd-44a1-a52f-455956baadbc"."clientmachine" = "localhost";
            "7843300b-b1dd-44a1-a52f-455956baadbc"."position" = "2334,0";
            "7843300b-b1dd-44a1-a52f-455956baadbc"."positionrule" = 3;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."screen" = 1;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."screenrule" = 2;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."title" = "Friends List";
            "7843300b-b1dd-44a1-a52f-455956baadbc"."titlematch" = 1;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."types" = 1;
            "7843300b-b1dd-44a1-a52f-455956baadbc"."wmclass" = "steamwebhelper";
            "7843300b-b1dd-44a1-a52f-455956baadbc"."wmclassmatch" = 1;
            "8"."Description" = "mumble (wayland)";
            "8"."clientmachine" = "localhost";
            "8"."ignoregeometry" = true;
            "8"."ignoregeometryrule" = 3;
            "8"."position" = "1723,0";
            "8"."positionrule" = 3;
            "8"."screen" = 1;
            "8"."screenrule" = 2;
            "8"."size" = "611,647";
            "8"."sizerule" = 3;
            "8"."wmclass" = "mumble";
            "8"."wmclasscomplete" = true;
            "8"."wmclassmatch" = 3;
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."Description" = "Application settings for obs";
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."clientmachine" = "localhost";
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."position" = "1003,646";
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."positionrule" = 3;
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."screen" = 1;
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."screenrule" = 2;
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."wmclass" = "obs";
            "8009dae4-25c1-401f-9ed3-0b5b49478b41"."wmclassmatch" = 1;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."Description" = "Window settings for steam";
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."clientmachine" = "localhost";
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."ignoregeometry" = true;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."ignoregeometryrule" = 3;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."position" = "2334,0";
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."positionrule" = 3;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."screen" = 1;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."screenrule" = 3;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."title" = "Friends List";
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."titlematch" = 1;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."types" = 1;
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."wmclass" = "steam";
            "8fdac71f-f762-490e-bc0d-a77a16efca9e"."wmclassmatch" = 1;
            "9"."Description" = "Move portal windows to primary screen";
            "9"."ignoregeometry" = true;
            "9"."ignoregeometryrule" = 3;
            "9"."screenrule" = 3;
            "9"."wmclass" = "xdg-desktop-portal-kde";
            "9"."wmclassmatch" = 1;
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."Description" = "Application settings for mumble";
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."clientmachine" = "localhost";
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."ignoregeometryrule" = 3;
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."position" = "1707,0";
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."positionrule" = 3;
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."screen" = 1;
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."screenrule" = 3;
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."wmclass" = "mumble";
            "94ccae6e-6008-4976-9b1f-bb7c8291b343"."wmclassmatch" = 1;
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."Description" = "Application settings for signal";
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."clientmachine" = "localhost";
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."position" = "1026,0";
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."positionrule" = 3;
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."screen" = 1;
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."screenrule" = 2;
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."wmclass" = "signal";
            "98305c64-adc2-474d-a6ff-47a96b33e2c8"."wmclassmatch" = 1;
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."Description" = "Application settings for armcord";
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."clientmachine" = "localhost";
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."ignoregeometryrule" = 3;
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."position" = "0,0";
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."positionrule" = 3;
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."screen" = 1;
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."screenrule" = 3;
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."wmclass" = "armcord";
            "9c6ea422-8783-48c7-848d-b16e254ba12a"."wmclassmatch" = 1;
            "General"."count" = 10;
            "General"."rules" = "1,2,b28b923a-6565-4f36-9608-d5c906e703f8,3,4,5,6,7,8,9";
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."Description" = "Application settings for armcord";
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."clientmachine" = "localhost";
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."ignoregeometry" = true;
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."ignoregeometryrule" = 2;
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."position" = "0,0";
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."positionrule" = 2;
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."screen" = 1;
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."screenrule" = 2;
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."wmclass" = "armcord";
            "a0e6e3db-ee9d-425d-86e8-566cf4803a32"."wmclassmatch" = 1;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."Description" = "fooyin (wayland)";
            "b28b923a-6565-4f36-9608-d5c906e703f8"."clientmachine" = "localhost";
            "b28b923a-6565-4f36-9608-d5c906e703f8"."ignoregeometry" = true;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."ignoregeometryrule" = 3;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."position" = "1026,646";
            "b28b923a-6565-4f36-9608-d5c906e703f8"."positionrule" = 3;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."screen" = 1;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."screenrule" = 2;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."size" = "1534,741";
            "b28b923a-6565-4f36-9608-d5c906e703f8"."sizerule" = 3;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."wmclass" = "fooyin";
            "b28b923a-6565-4f36-9608-d5c906e703f8"."wmclasscomplete" = true;
            "b28b923a-6565-4f36-9608-d5c906e703f8"."wmclassmatch" = 3;
            "b378570c-7775-4509-85ae-8bfe7334bf92"."Description" = "Application settings for mumble";
            "b378570c-7775-4509-85ae-8bfe7334bf92"."clientmachine" = "localhost";
            "b378570c-7775-4509-85ae-8bfe7334bf92"."position" = "1707,0";
            "b378570c-7775-4509-85ae-8bfe7334bf92"."positionrule" = 2;
            "b378570c-7775-4509-85ae-8bfe7334bf92"."screenrule" = 2;
            "b378570c-7775-4509-85ae-8bfe7334bf92"."wmclass" = "mumble";
            "b378570c-7775-4509-85ae-8bfe7334bf92"."wmclassmatch" = 1;
            "bc5d2de3-d928-44ae-a948-10ed69a1969c"."Description" = "Open windows on primary monitor";
            "bc5d2de3-d928-44ae-a948-10ed69a1969c"."ignoregeometry" = true;
            "bc5d2de3-d928-44ae-a948-10ed69a1969c"."ignoregeometryrule" = 3;
            "bc5d2de3-d928-44ae-a948-10ed69a1969c"."types" = 289;
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."Description" = "Application settings for foobar2000.exe";
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."clientmachine" = "localhost";
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."ignoregeometryrule" = 3;
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."position" = "0,646";
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."positionrule" = 2;
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."screen" = 1;
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."screenrule" = 2;
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."wmclass" = "foobar2000.exe";
            "c40c8ff8-c18f-4073-9475-74fee04b350b"."wmclassmatch" = 1;
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."Description" = "Application settings for info.mumble.Mumble";
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."position" = "1707,0";
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."positionrule" = 2;
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."screen" = 1;
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."screenrule" = 2;
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."wmclass" = "sinfo.mumble.Mumble";
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."wmclasscomplete" = true;
            "c661873f-f0c5-4bb7-a8d5-7ff92c15153f"."wmclassmatch" = 1;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."Description" = "Application settings for obs";
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."clientmachine" = "localhost";
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."ignoregeometry" = true;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."ignoregeometryrule" = 3;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."position" = "1003,646";
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."positionrule" = 2;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."screen" = 1;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."screenrule" = 2;
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."wmclass" = "obs";
            "c7677dfb-d66b-4645-b8ed-ded6e32640d5"."wmclassmatch" = 1;
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."Description" = "Application settings for strawberry";
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."clientmachine" = "localhost";
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."position" = "1010,646";
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."positionrule" = 2;
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."screen" = 1;
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."screenrule" = 2;
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."wmclass" = "strawberry";
            "d50bea36-d03b-4848-ad13-a4942979ebf8"."wmclassmatch" = 1;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."Description" = "Application settings for mumble";
            "d881282c-3c2e-40ed-8892-aa05136c361e"."clientmachine" = "localhost";
            "d881282c-3c2e-40ed-8892-aa05136c361e"."ignoregeometry" = true;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."ignoregeometryrule" = 2;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."position" = "1707,0";
            "d881282c-3c2e-40ed-8892-aa05136c361e"."positionrule" = 2;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."screen" = 1;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."screenrule" = 2;
            "d881282c-3c2e-40ed-8892-aa05136c361e"."wmclass" = "mumble";
            "d881282c-3c2e-40ed-8892-aa05136c361e"."wmclassmatch" = 1;
            "e3a10855-d298-4ade-bc95-efaf6961bf81"."Description" = "Application settings for dosbox-staging";
            "e3a10855-d298-4ade-bc95-efaf6961bf81"."clientmachine" = "localhost";
            "e3a10855-d298-4ade-bc95-efaf6961bf81"."screenrule" = 2;
            "e3a10855-d298-4ade-bc95-efaf6961bf81"."wmclass" = "dosbox-staging";
            "e3a10855-d298-4ade-bc95-efaf6961bf81"."wmclassmatch" = 1;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."Description" = "Application settings for obs";
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."clientmachine" = "localhost";
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."ignoregeometry" = true;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."ignoregeometryrule" = 3;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."position" = "1003,650";
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."positionrule" = 3;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."screen" = 1;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."screenrule" = 3;
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."wmclass" = "obs";
            "f21269fb-5a02-4135-b97a-17ff6f3c909a"."wmclassmatch" = 1;
          };
        };
        kwin = {
          effects.shakeCursor.enable = true;
          virtualDesktops = {
            animation = "slide";
            rows = 2;
            names = [
              "Main"
              "Scratch"
            ];
            number = 2;
          };
        };
        shortcuts = {
          kwin = {
            "Toggle Night Color" = "Meta+Shift+N";
            "Window Maximize" = "Meta+Shift+PgUp";
            "Window Minimize" = "Meta+Shift+PgDown";
            "Window Move Center" = [
              "Meta+C"
              "Meta+."
            ];
          };
        };
        hotkeys = {
          commands = {
            "Spectacle-region-clipboard" = {
              name = "Launch Spectacle with region capture";
              key = "Meta+Shift+Print";
              command = "spectacle -bcr";
              comment = "Region capture to clipboard";
            };
            "wezterm" = {
              name = "Launch wezterm";
              key = "F12";
              command = "wezterm";
              comment = "Launch wezterm";
            };
          };
        };
        spectacle.shortcuts = {
          captureActiveWindow = "Meta+Print";
          captureCurrentMonitor = "Print";
          captureEntireDesktop = "Shift+Print";
          #captureRectangularRegion = "Meta+Shift+S";
          captureWindowUnderCursor = "Meta+Ctrl+Print";
          launch = "Meta+S";
          launchWithoutCapturing = "Meta+Alt+S";
        };
        workspace = {
          clickItemTo = "select";
        };
      };
    };
}
