{ username, ... }:
{
  home-manager.users.${username} =
    {
      lib,
      username,
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      home = {
        file = {
          dolphinui = {
            enable = true;
            text = builtins.readFile ./dolphinui.rc;
            target = "${config.xdg.dataHome}/kxmlgui5/dolphin/dolphinui.rc";
          };
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
          editor = {
            brackets = {
              automaticallyAddClosing = true;
              flashMatching = true;
              highlightMatching = true;
              highlightRangeBetween = true;
            };
          };
          lsp = {
            customServers = {
              bash = {
                command = [
                  (lib.getExe pkgs.bash-language-server)
                  "start"
                ];
                url = "https://github.com/bash-lsp/bash-language-server";
                highlightingModeRegex = "^Bash$";
              };
              json = {
                command = [
                  (lib.getExe pkgs.vscode-json-languageserver)
                  "--stdio"
                ];
                url = "https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server";
                highlightingModeRegex = "^JSON$";
              };
              markdown = {
                command = [ (lib.getExe pkgs.marksman) ];
                url = "https://github.com/artempyanykh/marksman";
                highlightingModeRegex = "^Markdown$";
              };
              nix = {
                command = [ (lib.getExe pkgs.nixd) ];
                url = "https://github.com/nix-community/nixd";
                highlightingModeRegex = "^Nix$";
                settings.nixd = {
                  formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
                };
              };
              yaml = {
                command = [
                  (lib.getExe pkgs.yaml-language-server)
                  "--stdio"
                ];
                url = "https://github.com/redhat-developer/yaml-language-server";
                highlightingModeRegex = "^YAML$";
              };
            };
          };
        };
        konsole = {
          enable = true;
          defaultProfile = "${username}";
          extraConfig = {
            KonsoleWindow = {
              RemoveWindowTitleBarAndFrame = true;
            };
            MainWindow = {
              MenuBar = "Disabled";
            };
          };
          profiles = {
            "${username}" = {
              command = lib.getExe pkgs.zsh;
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
              "ContentDisplay"."UsePermissionsFormat" = "CombinedFormat";
              "Desktop Entry"."DefaultProfile" = "${username}.profile";
              "DetailsMode"."HighlightEntireRow" = false;
              "DetailsMode"."PreviewSize" = 48;
              "DetailsMode"."SidePadding" = 0;
              "General"."FilterBar" = true;
              "General"."GlobalViewProps" = false;
              "General"."ShowFullPath" = true;
              "General"."ShowFullPathInTitlebar" = true;
              "General"."ShowToolTips" = false;
              "General"."SplitView" = true;
              "General"."UseTabForSwitchingSplitView" = true;
              "IconsMode"."PreviewSize" = 112;
              "KFileDialog Settings"."Places Icons Auto-resize" = false;
              "KFileDialog Settings"."Places Icons Static Size" = 22;
              "MainWindow"."ToolBarsMovable" = "Disabled";
              "MainWindow/Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
              "PlacesPanel"."IconSize" = 32;
              "PreviewSettings"."Plugins" =
                "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,RomThumbnailCreator-kf6,svgthumbnail,ffmpegthumbs,ffmpegthumbnailer";
              "Search"."Location" = "Everywhere";
              "Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
            };
            kcminputrc = {
              "Keyboard"."RepeatDelay" = 250;
            };
            kded5rc = {
              "Module-device_automounter"."autoload" = false;
              "Module-gtkconfig"."autoload" = false;
            };
            kdeglobals = {
              "KDE"."AnimationDurationFactor" = 0.25;
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
              #"Plugins"."forceblurEnabled" = true;
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
              "Plugins"."contrastEnabled" = true;
              "Plugins"."kzonesEnabled" = false;
              "Plugins"."restoreToScreenEnabled" = true;
              "Round-Corners"."ActiveOutlinePalette" = 4;
              "Round-Corners"."ActiveOutlineUseCustom" = false;
              "Round-Corners"."ActiveOutlineUsePalette" = true;
              "Round-Corners"."ActiveSecondOutlinePalette" = 4;
              "Round-Corners"."ActiveSecondOutlineUseCustom" = false;
              "Round-Corners"."ActiveSecondOutlineUsePalette" = true;
              "Round-Corners"."InactiveOutlinePalette" = 4;
              "Round-Corners"."InactiveOutlineUseCustom" = false;
              "Round-Corners"."InactiveOutlineUsePalette" = true;
              "Round-Corners"."InactiveSecondOutlinePalette" = 4;
              "Round-Corners"."InactiveSecondOutlineUseCustom" = false;
              "Round-Corners"."InactiveSecondOutlineUsePalette" = true;
              "Round-Corners"."InactiveShadowSize" = 10;
              "Round-Corners"."ShadowSize" = 10;
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
            position = "center";
            activateWhenTypingOnDesktop = false;
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
                enable = true;
                strength = 3;
                noiseStrength = 3;
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
              "Kill Window" = "Alt+Shift+F4";
              "Toggle Night Color" = "Meta+Shift+N";
              "Window Maximize" = "Meta+PgUp";
              "Window Minimize" = "Meta+PgDown";
              "Window Move Center" = [
                "Meta+C"
                "Meta+."
              ];
              "Window No Border" = "Meta+Shift+B";
            };
            "services/org.kde.krunner.desktop"."_launch" = [
              "Meta+Space"
              "Alt+F2"
              "Search"
            ];
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
                key = "Meta+F12";
                command = "wezterm";
                comment = "Launch wezterm";
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
          windows = {
            allowWindowsToRememberPositions = true;
          };
          window-rules = [
            {
              description = "haruna";
              match = {
                window-class = {
                  value = "haruna";
                  type = "regex";
                };
              };
              apply = {
                maximizehoriz = {
                  value = true;
                  apply = "initially";
                };
                maximizevert = {
                  value = true;
                  apply = "initially";
                };
              };
            }
            {
              description = "icon: freetube";
              match = {
                window-class = {
                  value = "FreeTube";
                  type = "regex";
                };
              };
              apply = {
                desktopfile = "freetube.desktop";
                apply = "force";
              };
            }
            {
              description = "icon: libreoffice";
              match = {
                window-class = {
                  value = "libreoffice";
                  type = "regex";
                };
              };
              apply = {
                desktopfile = "startcenter";
                apply = "force";
              };
            }
            {
              description = "icon: signal";
              match = {
                window-class = {
                  value = "signal";
                  type = "regex";
                };
              };
              apply = {
                desktopfile = "signal";
                apply = "force";
              };
            }
            {
              description = "icon: virt-manager";
              match = {
                window-class = {
                  value = "virt-manager";
                  type = "regex";
                };
              };
              apply = {
                desktopfile = "virt-manager";
                apply = "force";
              };
            }
            {
              description = "icon: zen browser";
              match = {
                window-class = {
                  value = "zen";
                  type = "regex";
                };
              };
              apply = {
                desktopfile = "app.zen_browser.zen";
                apply = "force";
              };
            }
          ];
          workspace = {
            clickItemTo = "select";
            enableMiddleClickPaste = false;
            tooltipDelay = 300;
          };
        };
      };
    };
}
