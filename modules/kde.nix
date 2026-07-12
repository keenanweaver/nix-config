{
  flake.modules = {
    homeManager = {
      kde = { config, inputs, ... }: {
        home = {
          file = {
            dolphinui = {
              enable = true;
              target = "${config.xdg.dataHome}/kxmlgui5/dolphin/dolphinui.rc";
              text = builtins.readFile ./../assets/dolphinui.rc;
            };
            kinetic-effects = {
              enable = true;
              recursive = true;
              source = "${inputs.kwin-effects-kinetic}";
              target = "${config.xdg.dataHome}/kwin/effects";
            };
            purposerc = {
              enable = true;
              target = "${config.xdg.configHome}/purposerc";
              text = ''
                [plugins]
                disabled=emailplugin,imgurplugin,nextcloudplugin,pastebinplugin,purpose_gdrive,telegramplugin,youtubeplugin
              '';
            };
          };
          sessionVariables = {
            GDK_BACKEND = "wayland";
            QT_QPA_PLATFORM = "wayland";
          };
        };
      };
      plasma-manager =
        {
          lib,
          pkgs,
          inputs,
          osConfig,
          ...
        }:
        {
          imports = [
            inputs.plasma-manager.homeModules.plasma-manager
          ];

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
                    highlightingModeRegex = "^Bash$";
                    url = "https://github.com/bash-lsp/bash-language-server";
                  };
                  json = {
                    command = [
                      (lib.getExe pkgs.vscode-json-languageserver)
                      "--stdio"
                    ];
                    highlightingModeRegex = "^JSON$";
                    url = "https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server";
                  };
                  markdown = {
                    command = [ (lib.getExe pkgs.marksman) ];
                    highlightingModeRegex = "^Markdown$";
                    url = "https://github.com/artempyanykh/marksman";
                  };
                  nix = {
                    command = [ (lib.getExe pkgs.nixd) ];
                    highlightingModeRegex = "^Nix$";
                    settings.nixd = {
                      formatting.command = [ (lib.getExe pkgs.nixfmt) ];
                    };
                    url = "https://github.com/nix-community/nixd";
                  };
                  yaml = {
                    command = [
                      (lib.getExe pkgs.yaml-language-server)
                      "--stdio"
                    ];
                    highlightingModeRegex = "^YAML$";
                    url = "https://github.com/redhat-developer/yaml-language-server";
                  };
                };
              };
            };
            konsole = {
              enable = true;
              defaultProfile = "${osConfig.my.user}";
              extraConfig = {
                KonsoleWindow = {
                  RemoveWindowTitleBarAndFrame = true;
                };
                MainWindow = {
                  MenuBar = "Disabled";
                };
              };
              profiles = {
                "${osConfig.my.user}" = {
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
              configFile = {
                baloofilerc = {
                  "Basic Settings".Indexing-Enabled = false;
                };
                dolphinrc = {
                  ContentDisplay.UsePermissionsFormat = "CombinedFormat";
                  "Desktop Entry".DefaultProfile = "${osConfig.my.user}.profile";
                  DetailsMode = {
                    HighlightEntireRow = false;
                    PreviewSize = 48;
                    SidePadding = 0;
                  };
                  General = {
                    FilterBar = true;
                    GlobalViewProps = false;
                    ShowFullPath = true;
                    ShowFullPathInTitlebar = true;
                    ShowToolTips = false;
                    SplitView = true;
                    UseTabForSwitchingSplitView = true;
                  };
                  IconsMode.PreviewSize = 112;
                  "KFileDialog Settings"."Places Icons Auto-resize" = false;
                  "KFileDialog Settings"."Places Icons Static Size" = 22;
                  MainWindow.ToolBarsMovable = "Disabled";
                  "MainWindow/Toolbar mainToolBar".ToolButtonStyle = "IconOnly";
                  PlacesPanel.IconSize = 32;
                  PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,RomThumbnailCreator-kf6,svgthumbnail,ffmpegthumbs,ffmpegthumbnailer";
                  Search.Location = "Everywhere";
                  "Toolbar mainToolBar"."ToolButtonStyle" = "IconOnly";
                };
                kcminputrc = {
                  Keyboard.RepeatDelay = 250;
                };
                kded5rc = {
                  Module-device_automounter.autoload = false;
                  Module-gtkconfig.autoload = false;
                };
                kdeglobals = {
                  KDE.AnimationDurationFactor = 0.25;
                  KDE.ShowDeleteCommand = true;
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
                  KScreen.XwaylandClientsScale = false; # Steam workaround
                  PreviewSettings.MaximumRemoteSize = 2147483648;
                };
                kiorc = {
                  Confirmations = {
                    ConfirmDelete = true;
                    ConfirmEmptyTrash = true;
                    ConfirmTrash = false;
                  };
                  "Executable scripts".behaviourOnLaunch = "alwaysAsk";
                };
                klaunchrc = {
                  BusyCursorSettings.Bouncing = false;
                };
                kservicemenurc.Show = {
                  WriteCdImage = false;
                  compressfileitemaction = true;
                  extractfileitemaction = true;
                  forgetfileitemaction = true;
                  installFont = true;
                  kactivitymanagerd_fileitem_linking_plugin = true;
                  kdeconnectfileitemaction = true;
                  kio-admin = true;
                  makefileactions = true;
                  mountisoaction = true;
                  runInKonsole = true;
                  slideshowfileitemaction = true;
                  tagsfileitemaction = true;
                  wallpaperfileitemaction = true;
                };
                kwalletrc.Wallet."First Use" = false;
                kwinrc = {
                  Effect-blurplus = {
                    BlurMatching = false;
                    BlurNonMatching = true;
                    BlurStrength = 6;
                    RefractionStrength = 3;
                  };
                  Effect-windowview.BorderActivateAll = 9;
                  MouseBindings.CommandTitlebarWheel = "Change Opacity";
                  Plugins = {
                    MoveWindowToCenterEnabled = true;
                    contrastEnabled = true;
                    glassEnabled = false;
                    kinetic_fadingpopupsEnabled = true;
                    kinetic_scaleEnabled = true;
                    kinetic_squashEnabled = true;
                    kwin4_effect_fadingpopups_kineticEnabled = true;
                    kwin4_effect_maximizeEnabled = false;
                    kwin4_effect_maximize_kineticEnabled = true;
                    kwin4_effect_minimize_kineticEnabled = true;
                    kwin4_effect_open_close_kineticEnabled = true;
                    kwin4_effect_shapecornersEnabled = false;
                    kwin4_effect_squashEnabled = false;
                    kzonesEnabled = false;
                    restoreToScreenEnabled = true;
                  };
                  #Plugins.alwaysopenonprimaryscreen = Enabled;
                  #Plugins.center-new-windowsEnabled = true;
                  #Plugins.forceblurEnabled = true;
                  Round-Corners = {
                    ActiveOutlinePalette = 4;
                    ActiveOutlineUseCustom = false;
                    ActiveOutlineUsePalette = true;
                    ActiveSecondOutlinePalette = 4;
                    ActiveSecondOutlineUseCustom = false;
                    ActiveSecondOutlineUsePalette = true;
                    InactiveOutlinePalette = 4;
                    InactiveOutlineUseCustom = false;
                    InactiveOutlineUsePalette = true;
                    InactiveSecondOutlinePalette = 4;
                    InactiveSecondOutlineUseCustom = false;
                    InactiveSecondOutlineUsePalette = true;
                    InactiveShadowSize = 10;
                    ShadowSize = 10;
                  };
                  #Script-alwaysopenonprimaryscreen.classList = "steam\nsteamwebhelper\nmumble\ninfo.mumble.Mumble\nstrawberry\nobs\narmcord\nsignal";
                  Script-forceblur.blurExceptMatching = true;
                  Script-forceblur.blurMatching = false;
                  TabBox.LayoutName = "thumbnail_grid";
                  TabBoxAlternative.LayoutName = "thumbnails";
                  Tiling.padding = 4;
                  Windows = {
                    ActiveMouseScreen = false;
                    Placement = "Centered";
                    RollOverDesktops = true;
                  };
                  Xwayland.XwaylandEavesdrops = "Combinations";
                  Xwayland.XwaylandEavesdropsMouse = true;
                };
                session = {
                  general.askForConfirmationOnLogout = true;
                  sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
                };
                spectaclerc = {
                  General = {
                    autoSaveImage = true;
                    clipboardGroup = "PostScreenshotCopyImage";
                    launchAction = "DoNotTakeScreenshot";
                    useReleaseToCapture = true;
                  };
                };
                systemsettingsrc = {
                  "KFileDialog Settings".detailViewIconSize = 16;
                  systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;
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
              hotkeys = {
                commands = {
                  "Spectacle-region-clipboard" = {
                    command = "spectacle -bcr";
                    comment = "Region capture to clipboard";
                    key = "Meta+Shift+Print";
                    name = "Launch Spectacle with region capture";
                  };
                  "wezterm" = {
                    command = "wezterm";
                    comment = "Launch wezterm";
                    key = "Meta+F12";
                    name = "Launch wezterm";
                  };
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
                activateWhenTypingOnDesktop = false;
                historyBehavior = "enableSuggestions";
                position = "center";
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
                    noiseStrength = 3;
                    strength = 3;
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
                  location = {
                    latitude = "41.205500";
                    longitude = "-96.208814";
                  };
                  mode = "times";
                  temperature = {
                    day = 6500;
                    night = 3300;
                  };
                  time = {
                    evening = "20:00";
                    morning = "07:30";
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
                  names = [
                    "Main"
                    "Social"
                  ];
                  number = 2;
                  rows = 1;
                };
              };
              overrideConfig = false;
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
              spectacle.shortcuts = {
                captureActiveWindow = "Meta+Print";
                captureCurrentMonitor = "Print";
                captureEntireDesktop = "Shift+Print";
                captureRectangularRegion = "Meta+Shift+S";
                captureWindowUnderCursor = "Meta+Ctrl+Print";
                launch = "Meta+S";
                launchWithoutCapturing = "Meta+Alt+S";
              };
              window-rules = [
                # https://reddit.com/r/cachyos/comments/1rufws5/title_fullscreen_firefox_and_spectacle_screen/
                {
                  apply = {
                    adaptivesync = {
                      apply = "force";
                      value = false;
                    };
                  };
                  description = "Disable VRR for Spectacle";
                  match = {
                    window-class = {
                      type = "exact";
                      value = "org.kde.spectacle";
                    };
                  };
                }
                {
                  apply = {
                    maximizehoriz = {
                      apply = "initially";
                      value = true;
                    };
                    maximizevert = {
                      apply = "initially";
                      value = true;
                    };
                  };
                  description = "haruna";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "haruna";
                    };
                  };
                }
                {
                  apply = {
                    apply = "force";
                    desktopfile = "freetube.desktop";
                  };
                  description = "icon: freetube";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "FreeTube";
                    };
                  };
                }
                {
                  apply = {
                    apply = "force";
                    desktopfile = "startcenter";
                  };
                  description = "icon: libreoffice";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "libreoffice";
                    };
                  };
                }
                {
                  apply = {
                    apply = "force";
                    desktopfile = "signal";
                  };
                  description = "icon: signal";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "signal";
                    };
                  };
                }
                {
                  apply = {
                    apply = "force";
                    desktopfile = "virt-manager";
                  };
                  description = "icon: virt-manager";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "virt-manager";
                    };
                  };
                }
                {
                  apply = {
                    apply = "force";
                    desktopfile = "app.zen_browser.zen";
                  };
                  description = "icon: zen browser";
                  match = {
                    window-class = {
                      type = "regex";
                      value = "zen";
                    };
                  };
                }
              ];
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
    };
    nixos.kde = { config, pkgs, ... }: {
      environment = {
        plasma6.excludePackages = with pkgs.kdePackages; [ elisa ];
        sessionVariables = {
          GDK_DEBUG = "portals"; # KDE filepicker
        };
        systemPackages =
          with pkgs;
          with pkgs.kdePackages;
          [
            # https://github.com/shvedes/awesome-kde
            arianna
            breeze
            ffmpegthumbnailer
            filelight
            icoutils
            kaccounts-providers
            kcalc
            kdenetwork-filesharing
            kdesu
            kdialog
            kdotool
            kfind
            kget
            kgpg
            kio-fuse
            kirigami-addons
            kjournald
            kmousetool
            kompare
            krfb
            ksshaskpass
            ksystemlog
            #kzones
            markdownpart
            plasma-browser-integration
            packagekit-qt # Discover store
            qt6.qtwebengine
            qtimageformats
            qtsvg # https://github.com/NixOS/nixpkgs/issues/325225
            sddm-kcm
            (spectacle.override {
              tesseractLanguages = [ "eng" ];
            })
            svgpart
            syntax-highlighting
          ];
      };

      nixpkgs.overlays = [
        (final: prev: {
          kdePackages = prev.kdePackages.overrideScope (
            _kdeFinal: kdePrev: {
              # https://old.reddit.com/r/NixOS/comments/1pdtc3v/kde_plasma_is_slow_compared_to_any_other_distro/
              # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
              plasma-workspace =
                let
                  # the package we want to override
                  basePkg = kdePrev.plasma-workspace;
                  # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
                  # script and instead inject the path of the above helper package
                  derivedPkg = basePkg.overrideAttrs {
                    preFixup = ''
                      for index in "''${!qtWrapperArgs[@]}"; do
                        if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                          unset -v "qtWrapperArgs[$((index+0))]"
                          unset -v "qtWrapperArgs[$((index+1))]"
                          unset -v "qtWrapperArgs[$((index+2))]"
                          unset -v "qtWrapperArgs[$((index+3))]"
                        fi
                      done
                      qtWrapperArgs=("''${qtWrapperArgs[@]}")
                      qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                      qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                    '';
                  };
                  # a helper package that merges all the XDG_DATA_DIRS into a single directory
                  xdgdataPkg = final.stdenv.mkDerivation {
                    buildInputs = [ basePkg ];
                    dontFixup = true;
                    dontUnpack = true;
                    dontWrapQtApps = true;
                    installPhase = ''
                      mkdir -p $out/share
                      ( IFS=:
                        for DIR in $XDG_DATA_DIRS; do
                          if [[ -d "$DIR" ]]; then
                            ${prev.lib.getExe prev.lndir} -silent "$DIR" $out
                          fi
                        done
                      )
                    '';
                    name = "${basePkg.name}-xdgdata";
                  };
                in
                derivedPkg;
            }
          );
        })
      ];

      programs = {
        fuse.userAllowOther = true;
        kde-pim.enable = true;
        kdeconnect.enable = true;
        partition-manager.enable = true;
      };

      services = {
        colord.enable = true;
        desktopManager.plasma6.enable = true;
        displayManager = {
          autoLogin = {
            user = "${config.my.user}";
          };
          plasma-login-manager = {
            enable = true;
          };
        };
        libinput = {
          mouse.accelProfile = "flat";
          touchpad.accelProfile = "flat";
        };
      };

      xdg.portal = {
        config = {
          kde = {
            default = [
              "kde"
              "gtk"
            ];
            "org.freedesktop.portal.FileChooser" = [ "kde" ];
            "org.freedesktop.portal.OpenURI" = [ "kde" ];
          };
        };
        enable = true;
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    };
  };
  flake-file.inputs = {
    kwin-effects-glass = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:4v3ngR/kwin-effects-glass";
    };
    kwin-effects-kinetic = {
      flake = false;
      url = "github:gurrgur/kwin-effects-kinetic";
    };
    plasma-manager = {
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/plasma-manager";
    };
  };
}
