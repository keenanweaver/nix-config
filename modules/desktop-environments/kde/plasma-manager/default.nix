{ username, inputs, home-manager, ... }:
{
  home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
    programs.plasma = {
      enable = true;
      configFile = {
        "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;
        "kwinrc"."Desktops"."Number".value = 2;
        "systemsettingsrc"."KFileDialog Settings"."detailViewIconSize".value = 16;
        "systemsettingsrc"."systemsettings_sidebar_mode"."HighlightNonDefaultSettings".value = true;
        dolphinrc = {
          "Desktop Entry"."DefaultProfile".value = "${username}.profile";
          "DetailsMode"."HighlightEntireRow".value = false;
          "DetailsMode"."PreviewSize".value = 32;
          "DetailsMode"."SidePadding".value = 0;
          "General"."FilterBar".value = true;
          "General"."GlobalViewProps".value = false;
          "General"."RememberOpenedTabs".value = false;
          "General"."ShowFullPath".value = true;
          "General"."ShowFullPathInTitlebar".value = true;
          "General"."SplitView".value = true;
          "General"."UseTabForSwitchingSplitView".value = true;
          "IconsMode"."PreviewSize".value = 112;
          "KFileDialog Settings"."Places Icons Auto-resize".value = false;
          "KFileDialog Settings"."Places Icons Static Size".value = 32;
          "KFileDialog Settings"."detailViewIconSize".value = 16;
          "MainWindow.Toolbar mainToolBar"."ToolButtonStyle".value = "IconOnly";
          "PlacesPanel"."IconSize".value = 32;
          "Search"."Location".value = "Everywhere";
          "Toolbar mainToolBar"."ToolButtonStyle".value = "IconOnly";
        };
        kdeglobals = {
          "General"."AllowKDEAppsToRememberWindowPositions".value = true;
          "General"."BrowserApplication".value = "one.ablaze.floorp.desktop";
          "KDE"."AnimationDurationFactor".value = 0.5;
          "KDE"."ShowDeleteCommand".value = true;
          "KFileDialog Settings"."Allow Expansion".value = true;
          "KFileDialog Settings"."Automatically select filename extension".value = true;
          "KFileDialog Settings"."Breadcrumb Navigation".value = false;
          "KFileDialog Settings"."Decoration position".value = 2;
          "KFileDialog Settings"."LocationCombo Completionmode".value = 5;
          "KFileDialog Settings"."PathCombo Completionmode".value = 5;
          "KFileDialog Settings"."Show Bookmarks".value = true;
          "KFileDialog Settings"."Show Full Path".value = false;
          "KFileDialog Settings"."Show Inline Previews".value = false;
          "KFileDialog Settings"."Show Preview".value = false;
          "KFileDialog Settings"."Show Speedbar".value = true;
          "KFileDialog Settings"."Show hidden files".value = true;
          "KFileDialog Settings"."Sort by".value = "Name";
          "KFileDialog Settings"."Sort directories first".value = true;
          "KFileDialog Settings"."Sort hidden files last".value = true;
          "KFileDialog Settings"."Sort reversed".value = false;
          "KFileDialog Settings"."Speedbar Width".value = 133;
          "KFileDialog Settings"."View Style".value = "DetailTree";
          "KScreen"."XwaylandClientsScale".value = false; # Steam workaround
        };
        kwinrc = {
          "Effect-blur"."BlurStrength".value = 12;
          "Effect-windowview"."BorderActivateAll".value = 9;
          "NightColor"."Active".value = true;
          "NightColor"."MorningBeginFixed".value = 800;
          "NightColor"."NightTemperature".value = 3300;
          "Plugins"."MoveWindowToCenterEnabled".value = true;
          "Plugins"."alwaysopenonprimaryscreen".value = "Enabled";
          "Plugins"."blurEnabled".value = true;
          "Plugins"."glideEnabled".value = true;
          "Plugins"."kwin4_effect_fadingpopupsEnabled".value = false;
          "Plugins"."kwin4_effect_fadingpopups_kineticEnabled".value = true;
          "Plugins"."kwin4_effect_maximizeEnabled".value = false;
          "Plugins"."kwin4_effect_maximize_kineticEnabled".value = true;
          "Plugins"."kwin4_effect_minimize_kineticEnabled".value = true;
          "Plugins"."kwin4_effect_open_close_kineticEnabled".value = true;
          "Plugins"."kwin4_effect_scaleEnabled".value = false;
          "Plugins"."kwin4_effect_squashEnabled".value = false;
          "Plugins"."kwin4_effect_translucencyEnabled".value = true;
          "Plugins"."restoreToScreenEnabled".value = true;
          "Plugins"."scaleEnabled".value = false;
          "Plugins"."trackmouseEnabled".value = true;
          "Plugins"."translucencyEnabled".value = true;
          #"Plugins"."wobblywindowsEnabled" = true;
          "Script-alwaysopenonprimaryscreen"."classList".value = "steam\nsteamwebhelper\nmumble\ninfo.mumble.Mumble\nstrawberry\nobs\narmcord\nsignal";
          "Script-forceblur"."blurExceptMatching".value = true;
          "Script-forceblur"."blurMatching".value = false;
          "TabBox"."LayoutName".value = "thumbnail_grid";
          "TabBoxAlternative"."LayoutName".value = "thumbnails";
          "Windows"."ActiveMouseScreen".value = false;
          "Windows"."Placement".value = "Centered";
        };
        kwinrulesrc = { };
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
          "Window Maximize" = "Meta+Shift+PgUp";
          "Window Minimize" = "Meta+Shift+PgDown";
          "Window Move Center" = [ "Meta+C" "Meta+." ];
        };
        "services/org.kde.konsole.desktop"."_launch" = [ ];
        "services/Alacritty.desktop"."New" = "Ctrl+Alt+T";
        "services/Alacritty.desktop"."_launch" = "Ctrl+Alt+T";
      };
      hotkeys = {
        commands = {
          "alacritty" = {
            name = "Launch Alacritty";
            key = "Ctrl+Alt+T";
            command = "alacritty";
          };
          "Spectacle-region-clipboard" = {
            name = "Launch Spectacle with region capture";
            key = "Meta+Shift+Print";
            command = "spectacle -bcr";
          };
          "wezterm" = {
            name = "Launch wezterm";
            key = "F12";
            command = "wezterm";
          };
        };
      };
      spectacle.shortcuts = {
        captureActiveWindow = "Meta+Print";
        captureCurrentMonitor = "Print";
        captureEntireDesktop = "Shift+Print";
        captureRectangularRegion = "Meta+Shift+S";
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
