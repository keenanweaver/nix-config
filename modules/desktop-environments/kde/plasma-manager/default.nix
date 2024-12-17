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
      home = {
        file = {
          kinetic-effects = {
            enable = true;
            recursive = true;
            source = "${inputs.kwin-effects-kinetic}";
            target = "${config.xdg.dataHome}/kwin/effects";
          };
        };
      };
      programs = {
        ghostwriter = {
          enable = true;
          general = {
            session = {
              openLastFileOnStartup = true;
              rememberRecentFiles = true;
            };
          };
        };
        kate = {
          enable = true;
          lsp = {
            customServers = {
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
        };
        konsole = {
          enable = true;
          defaultProfile = "${username}";
          profiles = {
            "${username}" = {
              command = "${pkgs.zsh}/bin/zsh";
            };
          };
        };
        okular = {
          enable = true;
          general = {
            obeyDrm = false;
            openFileInTabs = true;
            showScrollbars = true;
            smoothScrolling = true;
            viewMode = "Facing";
            zoomMode = "fitWidth";
          };
          performance = {
            enableTransparencyEffects = true;
          };
        };
        plasma = {
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
              "General"."GlobalViewProps" = true;
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
              "PreviewSettings"."Plugins" =
                "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs,ffmpegthumbnailer";
              "Search"."Location" = "Everywhere";
              "Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
            };
            kcminputrc = {
              "Keyboard"."RepeatDelay" = 250;
            };
            "kded5rc"."Module-device_automounter"."autoload" = false;
            kdeglobals = {
              #"General"."TerminalApplication" = "konsole";
              #"General"."TerminalService" = "org.kde.konsole.desktop";
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
            session = {
              general.askForConfirmationOnLogout = true;
              sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
            };
            systemsettingsrc = {
              "KFileDialog Settings"."detailViewIconSize" = 16;
              "systemsettings_sidebar_mode"."HighlightNonDefaultSettings" = true;
            };
          };
          desktop = {
            icons = {
              alignment = "left";
              arrangement = "leftToRight";
              folderPreviewPopups = true;
              previewPlugins = [
                "appimagethumbnail"
                "audiothumbnail"
                "directorythumbnail"
                "ebookthumbnail"
                "ffmpegthumbs"
                "ffmpegthumbnailer"
                "fontthumbnail"
                "imagethumbnail"
                "jpegthumbnail"
                "windowsexethumbnail"
                "windowsimagethumbnail"
                "opendocumentthumbnail"
                "svgthumbnail"
                "textthumbnail"
              ];
              size = 3;
              sorting = {
                foldersFirst = true;
              };
            };
            mouseActions = {
              middleClick = "paste";
              rightClick = "contextMenu";
              verticalScroll = "switchVirtualDesktop";
            };
          };
          input = {
            keyboard = {
              layouts = [ { layout = "us"; } ];
              numlockOnStartup = "off";
              repeatDelay = 250;
              repeatRate = 25;
            };
          };
          krunner = {
            position = "top";
            activateWhenTypingOnDesktop = true;
            historyBehavior = "enableSuggestions";
          };
          kscreenlocker = {
            autoLock = false;
            lockOnResume = false;
          };
          kwin = {
            cornerBarrier = false;
            edgeBarrier = 0;
            effects = {
              blur = {
                enable = false;
                strength = 12;
                noiseStrength = 8;
              };
              cube.enable = true;
              desktopSwitching.animation = "slide";
              dimAdminMode.enable = false;
              dimInactive.enable = false;
              shakeCursor.enable = true;
              slideBack.enable = false;
              translucency.enable = true;
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
          spectacle.shortcuts = {
            captureActiveWindow = "Meta+Print";
            captureCurrentMonitor = "Print";
            captureEntireDesktop = "Shift+Print";
            #captureRectangularRegion = "Meta+Shift+S";
            captureWindowUnderCursor = "Meta+Ctrl+Print";
            launch = "Meta+S";
            launchWithoutCapturing = "Meta+Alt+S";
          };
          windows = {
            allowWindowsToRememberPositions = true;
          };
          workspace = {
            clickItemTo = "select";
            enableMiddleClickPaste = false;
            tooltipDelay = 300;
          };
        };
      };
    };
}
