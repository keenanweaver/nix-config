{
  config,
  inputs,
  lib,
  username,
  pkgs,
  vars,
  ...
}:
let
  accent-lower = "lavender";
  accent-upper = "Lavender";
  flavor-lower = "mocha";
  flavor-upper = "Mocha";
  cfg = config.catppuccinTheming;
  mono-font = "JetBrainsMono Nerd Font";
  sans-font = "Adwaita Sans";
  sans-font-pkg = pkgs.adwaita-fonts;
  #serif-font = "IBM Plex Serif";
  GTK-THEME = "Breeze-Dark";
  #cursor-theme = "breeze_cursors";
  cursor-theme = "catppuccin-${flavor-lower}-${accent-lower}-cursors";
  icon-theme = "Papirus-Dark";
in
{
  options = {
    catppuccinTheming = {
      enable = lib.mkEnableOption "Enable catppuccinTheming in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = "${accent-lower}";
      cache.enable = true;
      flavor = "${flavor-lower}";
      sddm = {
        background = ./wallpapers/lavender-wave-haikei.png;
        font = "${mono-font}";
        fontSize = "11";
      };
    };
    console = {
      packages = with pkgs; [ terminus_font ];
    };
    environment = {
      sessionVariables = {
        # Breaks theming but forces the color scheme
        #GTK_THEME = "${GTK-THEME}";
      };
      systemPackages = with pkgs; [
        (catppuccin-kde.override {
          accents = [ "${accent-lower}" ];
          flavour = [ "${flavor-lower}" ];
        })
        (catppuccin-papirus-folders.override {
          accent = "${accent-lower}";
          flavor = "${flavor-lower}";
        })
        #inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        inputs.lightly.packages.${system}.darkly-qt5
        inputs.lightly.packages.${system}.darkly-qt6
        utterly-round-plasma-style
      ];
    };
    services = {
      displayManager = {
        sddm = {
          settings = {
            Theme = {
              CursorTheme = "${cursor-theme}";
            };
          };
        };
      };
    };

    programs.dconf.enable = true;

    home-manager.users.${username} =
      {
        inputs,
        lib,
        config,
        username,
        pkgs,
        ...
      }:
      {
        catppuccin = {
          enable = true;
          accent = "${accent-lower}";
          flavor = "${flavor-lower}";
          cursors = {
            enable = true;
            accent = "${accent-lower}";
          };
          fzf = {
            accent = "${accent-lower}";
          };
          lazygit = {
            accent = "${accent-lower}";
          };
          micro = {
            transparent = true;
          };
          vscode = {
            accent = "${accent-lower}";
            settings.accent = "${accent-lower}";
          };
          yazi = {
            accent = "${accent-lower}";
          };
        };

        gtk = {
          enable = true;
          cursorTheme = {
            name = lib.mkDefault "${cursor-theme}";
            size = 24;
          };
          font = {
            name = "${sans-font}";
            size = 12;
            package = sans-font-pkg;
          };
          gtk2 = {
            configLocation = "${config.xdg.configHome}/.gtkrc-2.0"; # https://github.com/nix-community/plasma-manager/issues/472#issuecomment-2709114898
          };
          gtk3 = {
            extraConfig = {
              gtk-application-prefer-dark-theme = true;
              gtk-button-images = true;
              gtk-decoration-layout = "icon:minimize,maximize,close";
              gtk-enable-animations = true;
              gtk-menu-images = true;
              gtk-modules = "colorreload-gtk-module";
              gtk-primary-button-warps-slider = true;
              gtk-sound-theme-name = "ocean";
              gtk-toolbar-style = "3";
              gtk-xft-antialias = 1;
              gtk-xft-hinting = 1;
              gtk-xft-hintstyle = "hintslight";
              gtk-xft-rgba = "rgb";
            };
          };
          gtk4 = {
            extraConfig = {
              gtk-decoration-layout = "icon:minimize,maximize,close";
              gtk-enable-animations = true;
              gtk-primary-button-warps-slider = true;
              gtk-sound-theme-name = "ocean";
              gtk-xft-antialias = 1;
              gtk-xft-hinting = 1;
              gtk-xft-hintstyle = "hintslight";
              gtk-xft-rgba = "rgb";
            };
          };
          /*
            theme = {
                     name = "${GTK-THEME}";
                     package = pkgs.kdePackages.breeze-gtk;
                   };
          */
        };
        home = {
          file = {
            # UMU cursor workaround
            umu-breeze-cursors = {
              enable = false;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
              target = "${config.xdg.dataHome}/icons/breeze_cursors";
            };
            # Flatpak theming issue workarounds
            adwaita-font = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.adwaita-fonts}/share/fonts/Adwaita";
              target = "${config.xdg.dataHome}/fonts/Adwaita";
            };
            catppuccin-gtk = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze-gtk}/share/themes/${GTK-THEME}";
              target = "${config.xdg.dataHome}/themes/${GTK-THEME}";
            };
            catppuccin-ghostwriter = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-ghostwriter}/themes/catppuccin-${flavor-lower}-${accent-lower}.json";
              target = "${config.xdg.dataHome}/ghostwriter/themes/catppuccin-${flavor-lower}-${accent-lower}.json";
            };
            catppuccin-halloy = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-halloy}/themes/catppuccin-${flavor-lower}.toml";
              target = "${config.xdg.configHome}/halloy/themes/catppuccin-${flavor-lower}.toml";
            };
            catppuccin-heroic = {
              enable = vars.gaming;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-heroic}/themes/catppuccin-${flavor-lower}.css";
              target = "Games/Heroic/catppuccin-${flavor-lower}.css";
            };
            catppuccin-konsole = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/themes/catppuccin-${flavor-lower}.colorscheme";
              target = "${config.xdg.dataHome}/konsole/catppuccin-${flavor-lower}.colorscheme";
            };
            catppuccin-konsole-transparent = {
              enable = true;
              text = ''
                [Background]
                Color=30,30,46

                [BackgroundFaint]
                Color=30,30,46

                [BackgroundIntense]
                Color=30,30,46

                [Color0]
                Color=108,112,134

                [Color0Faint]
                Color=108,112,134

                [Color0Intense]
                Color=108,112,134

                [Color1]
                Color=243,139,168

                [Color1Faint]
                Color=243,139,168

                [Color1Intense]
                Color=243,139,168

                [Color2]
                Color=166,227,161

                [Color2Faint]
                Color=166,227,161

                [Color2Intense]
                Color=166,227,161

                [Color3]
                Color=249,226,175

                [Color3Faint]
                Color=249,226,175

                [Color3Intense]
                Color=249,226,175

                [Color4]
                Color=137,180,250

                [Color4Faint]
                Color=137,180,250

                [Color4Intense]
                Color=137,180,250

                [Color5]
                Color=203,166,247

                [Color5Faint]
                Color=203,166,247

                [Color5Intense]
                Color=203,166,247

                [Color6]
                Color=137,220,235

                [Color6Faint]
                Color=137,220,235

                [Color6Intense]
                Color=137,220,235

                [Color7]
                Color=205,214,244

                [Color7Faint]
                Color=205,214,244

                [Color7Intense]
                Color=205,214,244

                [Foreground]
                Color=205,214,244

                [ForegroundFaint]
                Color=205,214,244

                [ForegroundIntense]
                Color=205,214,244

                [General]
                Blur=false
                ColorRandomization=false
                Description=Catppuccin Mocha (transparent)
                Opacity=0.7
                Wallpaper=
              '';
              target = "${config.xdg.dataHome}/konsole/catppuccin-${flavor-lower}-transparent.colorscheme";
            };
            catppuccin-krita = {
              enable = true;
              text = builtins.readFile ./krita/CatppuccinMochaLavender.colors;
              target = "${config.xdg.dataHome}/krita/color-schemes/Catppuccin${flavor-upper}${accent-upper}.colors";
            };
            catppuccin-obs-flatpak = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-obs}/themes";
              target = ".var/app/com.obsproject.Studio/config/obs-studio/themes";
            };
            catppuccin-powershell = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-powershell}";
              target = "${config.xdg.dataHome}/powershell/Modules/Catppuccin";
            };
            catppuccin-vesktop = {
              enable = true;
              text = ''
                @import url("https://catppuccin.github.io/discord/dist/catppuccin-${flavor-lower}-${accent-lower}.theme.css");
              '';
              target = "${config.xdg.configHome}/vesktop/themes/${flavor-lower}.theme.css";
            };
            catppuccin-zen-flatpak = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-zen}/themes/${flavor-upper}/${accent-upper}";
              target = ".var/app/app.zen_browser.zen/.zen/${username}/chrome";
            };
            cursor-theme-default = {
              enable = false;
              text = ''
                [Icon Theme]
                Inherits=${cursor-theme}
              '';
              target = "${config.xdg.dataHome}/icons/default/index.theme";
            };
            darkly-config = {
              enable = true;
              text = ''
                [Common]
                OutlineCloseButton=false
                ShadowSize=ShadowMedium

                [Style]
                DolphinSidebarOpacity=70
                MenuBarOpacity=70
                MenuItemDrawStrongFocus=false
                MenuOpacity=70
                ToolBarOpacity=70
                renderThinSeperatorBetweenTheScrollBar=true
                [Windeco]

                DrawBackgroundGradient=false
              '';
              target = "${config.xdg.configHome}/darklyrc";
            };
            gtk3-config-colors = {
              enable = true;
              text = builtins.readFile ./gtk-3.0/colors.css;
              target = "${config.xdg.configHome}/gtk-3.0/colors.css";
            };
            gtk3-config-gtk = {
              enable = true;
              text = builtins.readFile ./gtk-3.0/gtk.css;
              target = "${config.xdg.configHome}/gtk-3.0/gtk.css";
            };
            gtk4-config-colors = {
              enable = true;
              text = builtins.readFile ./gtk-4.0/colors.css;
              target = "${config.xdg.configHome}/gtk-4.0/colors.css";
            };
            gtk4-config-gtk = {
              enable = true;
              text = builtins.readFile ./gtk-4.0/gtk.css;
              target = "${config.xdg.configHome}/gtk-4.0/gtk.css";
            };
            klassy-config = {
              enable = false;
              text = ''
                [ButtonBehaviour]
                ShowCloseOutlineOnHoverActive=false
                ShowCloseOutlineOnHoverInactive=false
                ShowCloseOutlineOnPressActive=false
                ShowCloseOutlineOnPressInactive=false
                ShowOutlineOnHoverActive=false
                ShowOutlineOnHoverInactive=false
                ShowOutlineOnPressActive=false
                ShowOutlineOnPressInactive=false

                [ButtonColors]
                ButtonBackgroundColorsActive=TitleBarTextNegativeClose
                ButtonBackgroundColorsInactive=TitleBarTextNegativeClose
                ButtonBackgroundOpacityActive=10
                ButtonBackgroundOpacityInactive=10
                ButtonOverrideColorsActiveClose={"BackgroundHover":["NegativeFullySaturated"],"BackgroundPress":["NegativeSaturated",80]}
                ButtonOverrideColorsInactiveClose={"BackgroundHover":["NegativeFullySaturated"],"BackgroundPress":["NegativeSaturated",80]}
                OnPoorIconContrastActive=Nothing
                OnPoorIconContrastInactive=Nothing

                [ButtonSizing]
                ButtonCornerRadius=Custom
                ButtonCustomCornerRadius=0
                FullHeightButtonSpacingLeft=0
                FullHeightButtonSpacingRight=0
                FullHeightButtonWidthMarginRight=14
                IntegratedRoundedRectangleBottomPadding=0.5

                [ShadowStyle]
                ShadowSize=ShadowSmall

                [TitleBarOpacity]
                ActiveTitleBarOpacity=75

                [TitleBarSpacing]
                LockTitleBarLeftRightMargins=false
                PercentMaximizedTopBottomMargins=50
                TitleAlignment=AlignLeft
                TitleBarBottomMargin=2.25
                TitleBarLeftMargin=2
                TitleBarTopMargin=2.25

                [Windeco]
                BoldButtonIcons=BoldIconsFine
                ButtonIconStyle=StyleSystemIconTheme
                ButtonShape=ShapeFullHeightRectangle
                ColorizeThinWindowOutlineWithButton=false
                IconSize=IconMedium
                WindowCornerRadius=8

                [WindowOutlineStyle]
                LockThinWindowOutlineStyleActiveInactive=true
                ThinWindowOutlineStyleActive=WindowOutlineContrast
                ThinWindowOutlineStyleInactive=WindowOutlineContrast
              '';
              target = "${config.xdg.configHome}/klassy/klassyrc";
            };
            powershell-profile = {
              enable = true;
              text = ''
                Import-Module Catppuccin
                $Flavor = $Catppuccin['${flavor-upper}']
              '';
              target = "${config.xdg.configHome}/powershell/Microsoft.PowerShell_profile.ps1";
            };
          };
          packages = with pkgs; [
            hicolor-icon-theme
            vivid
            ## GNOME
            adwaita-icon-theme
            gnome-settings-daemon
            gsettings-desktop-schemas
            gsettings-qt
          ];
          sessionVariables = {
            GSETTINGS_BACKEND = "keyfile";
            GTK_USE_PORTAL = "1";
            LS_COLORS = "$(vivid generate catppuccin-${flavor-lower})";
            XCURSOR_NAME = "${cursor-theme}";
            XCURSOR_SIZE = "24";
          };
        };
        programs = {
          bat = {
            config = {
              pager = "less -FR";
            };
          };
          btop = {
            settings = {
              theme_background = false;
            };
          };
          foot = {
            settings = {
              colors = {
                alpha = 0.7;
              };
              main = {
                font = "${mono-font}:size=12";
              };
            };
          };
          git = {
            delta = { };
          };
          helix = {
            settings = {
              theme = lib.mkForce "catppuccin_transparent";
            };
            themes = {
              catppuccin_transparent = {
                "inherits" = "catppuccin-${flavor-lower}";
                "ui.background" = "none";
              };
            };
          };
          kate = {
            editor = {
              brackets = {
                automaticallyAddClosing = true;
                flashMatching = true;
                highlightMatching = true;
                highlightRangeBetween = true;
              };
              font = {
                family = "${mono-font}";
                pointSize = 14;
              };
            };
          };
          kitty = {
            font = {
              name = "${mono-font}";
              size = 14;
            };
            settings = {
              background_opacity = "0.7";
            };
          };
          konsole = {
            profiles = {
              "${username}" = {
                colorScheme = "catppuccin-${flavor-lower}-transparent";
                font = {
                  name = "${mono-font}";
                  size = 14;
                };
              };
            };
          };
          lazygit = {
            settings = {
              gui = {
                border = "single";
                mainPanelSplitMode = "vertical";
                nerdFontsVersion = "3";
                scrollHeight = 10;
                scrollOffMargin = 4;
                showFileTree = false;
                sidePanelWidth = 0.3333;
              };
            };
          };
          nvf = {
            settings = {
              vim = {
                theme = {
                  enable = true;
                  name = "catppuccin";
                  style = "mocha";
                  transparent = true;
                };
              };
            };
          };
          plasma = {
            configFile = {
              # Application Style
              "kdeglobals"."KDE"."widgetStyle" = "Darkly";
            };
            fonts = {
              general = {
                family = "${sans-font}";
                pointSize = 12;
              };
              fixedWidth = {
                family = "${mono-font}";
                pointSize = 14;
              };
              small = {
                family = "${sans-font}";
                pointSize = 12;
              };
              toolbar = {
                family = "${sans-font}";
                pointSize = 12;
              };
              menu = {
                family = "${sans-font}";
                pointSize = 12;
              };
              windowTitle = {
                family = "${sans-font}";
                pointSize = 12;
              };
            };
            kscreenlocker = {
              appearance = {
                wallpaper = ./wallpapers/lavender-wave-haikei.png;
              };
            };
            workspace = {
              # Global theme
              # plasma-apply-lookandfeel --list
              #lookAndFeel = "Catppuccin-${flavor-upper}-${accent-upper}";
              # Colors
              # plasma-apply-colorscheme --list-schemes
              colorScheme = "Catppuccin${flavor-upper}${accent-upper}";
              # Plasma Style
              # plasma-apply-desktoptheme --list-themes
              theme = "Utterly-Round";
              # Window decorations
              windowDecorations = {
                library = "org.kde.darkly";
                theme = "Darkly";
              };
              # Icons
              iconTheme = "${icon-theme}";
              # Cursors
              # plasma-apply-cursortheme --list-themes
              cursor = {
                size = 24;
                theme = "${cursor-theme}";
              };
              # System sounds
              soundTheme = "ocean";
              # Splash Screen
              splashScreen.theme = "Catppuccin-${flavor-upper}-${accent-upper}";
              # Wallpaper
              wallpaper = ./wallpapers/lavender-wave-haikei.png;
            };
          };
          vscode = {
            profiles = {
              default = {
                userSettings = {
                  "editor.fontFamily" = "'${mono-font}', 'monospace', monospace";
                  "editor.fontLigatures" = true;
                  "editor.fontSize" = 18;
                  "terminal.integrated.fontFamily" = "${mono-font}";
                  "terminal.integrated.fontSize" = 14;
                  "terminal.integrated.fontWeight" = "normal";
                  "workbench.iconTheme" = "catppuccin-${flavor-lower}";
                };
              };
            };
          };
        };
        services = {
          flatpak = {
            overrides = {
              "com.fightcade.Fightcade" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
              "app.zen_browser.zen" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
            };
          };
          xsettingsd = {
            settings = {
              "Gtk/CursorThemeSize" = 24;
              "Gtk/CursorThemeName" = "${cursor-theme}";
              "Gtk/FontName" = "${sans-font},  12";
              "Net/IconThemeName" = "${icon-theme}";
              "Net/ThemeName" = "${GTK-THEME}";
            };
          };
        };

        xresources = {
          properties = {
            "Xcursor.size" = 24;
            "Xcursor.theme" = "${cursor-theme}";
            "Xft.autohint" = 1;
            "Xft.lcdfilter" = "lcddefault";
            "Xft.hintstyle" = "hintfull";
            "Xft.hinting" = 1;
            "Xft.antialias" = 1;
            "Xft.rgba" = "rgb";
            # Catppuccin
            "*background" = "#1E1E2E";
            "*foreground" = "#CDD6F4";
            "*color0" = "#45475A";
            "*color8" = "#585B70";
            "*color1" = "#F38BA8";
            "*color9" = "#F38BA8";
            "*color2" = "#A6E3A1";
            "*color10" = "#A6E3A1";
            "*color3" = "#F9E2AF";
            "*color11" = "#F9E2AF";
            "*color4" = "#89B4FA";
            "*color12" = "#89B4FA";
            "*color5" = "#F5C2E7";
            "*color13" = "#F5C2E7";
            "*color6" = "#94E2D5";
            "*color14" = "#94E2D5";
            "*color7" = "#BAC2DE";
            "*color15" = "#A6ADC8";
          };
        };
      };
  };
}
