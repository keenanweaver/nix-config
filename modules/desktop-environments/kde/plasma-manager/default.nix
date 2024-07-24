{ username, ... }:
{
  home-manager.users.${username} =
    {
      username,
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      home.file = {
        kinetic-effects = {
          enable = true;
          recursive = true;
          source = "${inputs.kwin-effects-kinetic}";
          target = "${config.xdg.dataHome}/kwin/effects";
        };
      };
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
          baloofilerc = {
            "Basic Settings"."Indexing-Enabled" = false;
          };
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
            "MainWindow/Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
            "PlacesPanel"."IconSize" = 32;
            "PreviewSettings"."Plugins" = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
            "Search"."Location" = "Everywhere";
            "Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
          };
          kactivitymanagerdrc = {
            "activities"."21bdfd7b-33e2-496a-bd6c-3c85c68aea44" = "Default";
            "main"."currentActivity" = "21bdfd7b-33e2-496a-bd6c-3c85c68aea44";
          };
          kcminputrc = {
            "Keyboard"."RepeatDelay" = 250;
            "Libinput/1133/16543/Logitech G502 X LS"."PointerAccelerationProfile" = 1;
          };
          "kded5rc"."Module-device_automounter"."autoload" = false;
          kdeglobals = {
            "General"."TerminalApplication" = "kitty";
            "General"."TerminalService" = "kitty.desktop";
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
            "KFileDialog Settings"."Show hidden files" = false;
            "KFileDialog Settings"."Sort by" = "Name";
            "KFileDialog Settings"."Sort directories first" = true;
            "KFileDialog Settings"."Sort hidden files last" = true;
            "KFileDialog Settings"."Sort reversed" = false;
            "KFileDialog Settings"."Speedbar Width" = 133;
            "KFileDialog Settings"."View Style" = "DetailTree";
            "KScreen"."XwaylandClientsScale" = false; # Steam workaround
            "PreviewSettings"."MaximumRemoteSize" = 2147483648;
          };
          kiorc = {
            "Confirmations"."ConfirmDelete" = true;
            "Confirmations"."ConfirmEmptyTrash" = true;
            "Confirmations"."ConfirmTrash" = false;
            "Executable scripts"."behaviourOnLaunch" = "alwaysAsk";
          };
          klaunchrc = {
            "BusyCursorSettings"."Bouncing" = false;
          };
          kscreenlockerrc = {
            "Daemon"."Autolock" = false;
          };
          kservicemenurc = {
            "Show"."WriteCdImage" = false;
            "Show"."compressfileitemaction" = true;
            "Show"."extractfileitemaction" = true;
            "Show"."forgetfileitemaction" = true;
            "Show"."installFont" = true;
            "Show"."kactivitymanagerd_fileitem_linking_plugin" = true;
            "Show"."kdeconnectfileitemaction" = true;
            "Show"."kio-admin" = true;
            "Show"."makefileactions" = true;
            "Show"."mountisoaction" = true;
            "Show"."runInKonsole" = true;
            "Show"."slideshowfileitemaction" = true;
            "Show"."tagsfileitemaction" = true;
            "Show"."wallpaperfileitemaction" = true;
          };
          "kwalletrc"."Wallet"."First Use" = false;
          kwinrc = {
            "Desktops"."Id_1" = "a7432ce6-58b8-4c67-92e7-165c462be689"; # Main
            "Desktops"."Id_2" = "913f595f-b9b9-46ac-9448-99b3a463d45e"; # Social
            "Effect-blur"."BlurStrength" = 12;
            "Effect-windowview"."BorderActivateAll" = 9;
            "MouseBindings"."CommandTitlebarWheel" = "Change Opacity";
            "Plugins"."MoveWindowToCenterEnabled" = true;
            #"Plugins"."alwaysopenonprimaryscreen" = "Enabled";
            #"Plugins"."center-new-windowsEnabled" = true;
            "Plugins"."forceblurEnabled" = true;
            "Plugins"."kinetic_fadingpopupsEnabled" = true;
            "Plugins"."kinetic_scaleEnabled" = true;
            "Plugins"."kinetic_squashEnabled" = true;
            "Plugins"."kwin4_effect_fadingpopups_kineticEnabled" = true;
            "Plugins"."kwin4_effect_maximizeEnabled" = false;
            "Plugins"."kwin4_effect_maximize_kineticEnabled" = true;
            "Plugins"."kwin4_effect_minimize_kineticEnabled" = true;
            "Plugins"."kwin4_effect_open_close_kineticEnabled" = true;
            "Plugins"."kwin4_effect_shapecornersEnabled" = false;
            "Plugins"."kwin4_effect_squashEnabled" = false;
            "Plugins"."restoreToScreenEnabled" = true;
            #"Script-alwaysopenonprimaryscreen"."classList" = "steam\nsteamwebhelper\nmumble\ninfo.mumble.Mumble\nstrawberry\nobs\narmcord\nsignal";
            "Script-forceblur"."blurExceptMatching" = true;
            "Script-forceblur"."blurMatching" = false;
            "TabBox"."LayoutName" = "thumbnail_grid";
            "TabBoxAlternative"."LayoutName" = "thumbnails";
            "Tiling"."padding" = 4;
            "Windows"."ActiveMouseScreen" = false;
            "Windows"."Placement" = "Centered";
            "Windows"."RollOverDesktops" = true;
            "Xwayland"."XwaylandEavesdrops" = "Combinations";
          };
          systemsettingsrc = {
            "KFileDialog Settings"."detailViewIconSize" = 16;
            "systemsettings_sidebar_mode"."HighlightNonDefaultSettings" = true;
          };
        };
        kwin = {
          effects = {
            blur.enable = false;
            desktopSwitching.animation = "slide";
            dimInactive.enable = false;
            dimAdminMode.enable = false;
            shakeCursor.enable = true;
            slideBack.enable = false;
            /*
              minimization = {
                         #animation = "squash";
                         #duration = 50;
                       };
            */
            translucency.enable = true;
            #windowOpenClose.animation = "glide";
            wobblyWindows.enable = false;
          };
          nightLight = {
            enable = true;
            mode = "times";
            location = {
              latitude = "41.205500";
              longitude = "-96.208814";
            };
            temperature = {
              day = 6500;
              night = 3300;
            };
            time = {
              morning = "07:30";
              evening = "20:00";
            };
            transitionTime = 30;
          };
          titlebarButtons = {
            left = null;
            right = [
              "minimize"
              "maximize"
              "close"
            ];
          };
          virtualDesktops = {
            rows = 1;
            names = [
              "Main"
              "Social"
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
        powerdevil = {
          autoSuspend.action = "nothing";
          turnOffDisplay = {
            idleTimeout = 900;
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
        /*
          windows = {
                 allowWindowsToRememberPositions = true;
               };
        */
        workspace = {
          clickItemTo = "select";
        };
      };
    };
}
