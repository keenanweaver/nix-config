{
  config,
  lib,
  username,
  pkgs,
  dotfiles,
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
  sans-font = "Geist";
  serif-font = "IBM Plex Serif";
  GTK-THEME = "Breeze-Dark";
  cursor-theme = "breeze_cursors";
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
      flavor = "${flavor-lower}";
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
        (callPackage ../../../nix/pkgs/klassy.nix { })
        utterly-round-plasma-style
      ];
    };
    services = {
      displayManager = {
        sddm = {
          catppuccin = {
            background = "${dotfiles}/Pictures/wallpapers/lavender-wave-haikei.png";
            font = "${mono-font}";
            fontSize = "11";
          };
          settings = {
            Theme = {
              CursorTheme = "${cursor-theme}";
            };
          };
        };
      };
    };

    programs.dconf.enable = true;

    /*
      stylix = {
         autoEnable = false;
         base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-${flavor-lower}.yaml";
         cursor = {
           name = "${cursor-theme}";
           size = 24;
         };
         fonts = {
           monospace = {
             name = "${mono-font}";
             package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
           };
           sansSerif = {
             name = "${sans-font}";
             package = pkgs.ibm-plex;
           };
           serif = {
             name = "${serif-font}";
             package = pkgs.ibm-plex;
           };
           sizes = {
             applications = 13;
             desktop = 13;
             popups = 11;
             terminal = 13;
           };
         };
         image = "${dotfiles}/Pictures/wallpapers/lavender-low-poly-grid-haikei.png";
         opacity = {
           applications = 1.0;
           terminal = 0.7;
           desktop = 1.0;
           popups = 1.0;
         };
         polarity = "dark";
         targets = {
           chromium.enable = true;
           gtk.enable = true;
         };
       };
    */

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
        };

        /*
          stylix = {
                 autoEnable = false;
                 targets = {
                   #mangohud.enable = if vars.gaming then true else false;
                   xresources.enable = true;
                 };
               };
        */

        colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

        gtk = {
          enable = true;
          catppuccin = {
            enable = false;
            size = "standard";
            tweaks = [ "normal" ];
          };
          cursorTheme = {
            name = lib.mkDefault "${cursor-theme}";
            size = 24;
          };
          font = {
            name = "${sans-font}";
            size = 12;
            package = pkgs.geist-font;
          };
          gtk2 = {
            configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
            # force = true; # https://github.com/nix-community/home-manager/pull/5263
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
            # Flatpak theming issue workarounds
            catppuccin-gtk = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze-gtk}/share/themes/${GTK-THEME}";
              target = "${config.xdg.dataHome}/themes/${GTK-THEME}";
            };
            catppuccin-armcord = {
              enable = true;
              text = ''
                @import url("https://catppuccin.github.io/discord/dist/catppuccin-${flavor-lower}-${accent-lower}.theme.css");
              '';
              target = ".var/app/xyz.armcord.ArmCord/config/ArmCord/themes/${flavor-lower}.theme.css";
            };
            catppuccin-halloy = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-halloy}/catppuccin-${flavor-lower}.toml";
              target = ".var/app/org.squidowl.halloy/config/halloy/themes/catppuccin-${flavor-lower}.toml";
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
            catppuccin-obs-flatpak = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-obs}/themes";
              target = ".var/app/com.obsproject.Studio/config/obs-studio/themes/";
            };
            catppuccin-obs = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-obs}/themes";
              target = "${config.xdg.configHome}/obs-studio/themes/";
            };
            catppuccin-powershell = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-powershell}";
              target = "${config.xdg.dataHome}/powershell/Modules/Catppuccin";
            };
            font-geist = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.geist-font}/share/fonts/opentype";
              target = "${config.xdg.dataHome}/fonts/geist";
            };
            klassy-config = {
              enable = true;
              text = ''
                [Global]
                LookAndFeelSet=Catppuccin-${flavor-upper}-${accent-upper}

                [SystemIconGeneration]
                KlassyDarkIconThemeInherits=Papirus-Dark
                KlassyIconThemeInherits=Papirus

                [TitleBarOpacity]
                ActiveTitleBarOpacity=70
                InactiveTitleBarOpacity=70

                [Windeco]
                ButtonIconStyle=StyleSystemIconTheme

                [WindowOutlineStyle]
                ThinWindowOutlineThickness=1
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
            wayland-cursor-fix = {
              enable = true;
              text = ''
                [Icon Theme]
                Inherits=${cursor-theme}
              '';
              target = "${config.xdg.dataHome}/icons/default/index.theme";
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
                colorScheme = "catppuccin-${flavor-lower}";
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
          nixvim = {
            colorschemes.catppuccin = {
              enable = true;
              settings = {
                background.dark = "${flavor-lower}";
                flavor = "${flavor-lower}";
                integrations = {
                  cmp = true;
                  coc_nvim = true;
                  gitsigns = true;
                  markdown = true;
                  neotree = true;
                  overseer = true;
                  treesitter = true;
                  treesitter_context = true;
                  which_key = true;
                };
                term_colors = true;
                transparentBackground = true;
              };
            };
          };
          plasma = {
            configFile = {
              # Application Style
              "kdeglobals"."KDE"."widgetStyle" = "Klassy";
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
                wallpaper = "${dotfiles}/Pictures/wallpapers/lavender-wave-haikei.png";
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
                library = "org.kde.klassy";
                theme = "Klassy";
              };
              # Icons
              iconTheme = "Papirus-Dark";
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
              wallpaper = "${dotfiles}/Pictures/wallpapers/lavender-wave-haikei.png";
            };
          };
          vscode = {
            extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
              catppuccin.catppuccin-vsc-icons
              catppuccin.catppuccin-vsc
            ];
            userSettings = {
              "catppuccin.accentColor" = "${accent-lower}";
              "catppuccin.customUIColors"."${flavor-lower}"."statusBar.foreground" = "accent";
              "editor.fontFamily" = "'${mono-font}', 'monospace', monospace";
              "editor.fontLigatures" = true;
              "editor.fontSize" = 18;
              "glassit.alpha" = 210;
              "terminal.integrated.fontFamily" = "${mono-font}";
              "terminal.integrated.fontSize" = 14;
              "terminal.integrated.fontWeight" = "normal";
              "workbench.colorTheme" = "Catppuccin ${flavor-upper}";
              "workbench.iconTheme" = "catppuccin-${flavor-lower}";
            };
          };
          /*
            zed-editor = {
                     userSettings = ''
                       {
                         "buffer_font_family": "JetBrainsMono",
                         "theme": "Catppuccin Mocha",
                         "Catppuccin Mocha.theme_overrides: {
                           "background.appearance": "blurred",
                         },
                       }
                     '';
                   };
          */
        };
        services = {
          flatpak = {
            overrides = {
              "com.fightcade.Fightcade" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
              "io.github.zen_browser.zen" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
              "one.ablaze.floorp" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
              "org.signal.Signal" = {
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
              "Net/IconThemeName" = "Papirus-Dark";
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
