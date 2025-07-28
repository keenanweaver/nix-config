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
  mono-font = "Maple Mono Normal NF";
  sans-font = "Inter";
  sans-font-pkg = pkgs.inter;
  #serif-font = "IBM Plex Serif";
  GTK-THEME = "Breeze-Dark";
  #cursor-theme = "breeze_cursors";
  cursor-theme = "catppuccin-${flavor-lower}-${accent-lower}-cursors";
  icon-theme = "Papirus-Dark";
  #wallpaper = "lavender-wave-haikei.png";
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/2k/wallhaven-2kpexy.jpg";
    hash = "sha256-vSzbsrAg6EalV5FzvHPQRS1qdhjJpDSjda4M+s8ACU4=";
  };
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
        background = "${wallpaper}";
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
        #inputs.lightly.packages.${system}.darkly-qt5
        inputs.lightly.packages.${system}.darkly-qt6
        klassy
        plasma-panel-colorizer
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
          mangohud.enable = false;
          micro = {
            transparent = true;
          };
          vesktop.enable = false;
          vscode = {
            profiles.default = {
              accent = "${accent-lower}";
            };
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
            force = true;
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
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-heroic}/themes/catppuccin-${flavor-lower}-${accent-lower}.css";
              target = "Games/Heroic/catppuccin-${flavor-lower}-${accent-lower}.css";
            };
            catppuccin-konsole = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/themes/catppuccin-${flavor-lower}.colorscheme";
              target = "${config.xdg.dataHome}/konsole/catppuccin-${flavor-lower}.colorscheme";
            };
            catppuccin-konsole-transparent = {
              enable = true;
              text = builtins.readFile ./catppuccin-mocha-transparent.colorscheme;
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
              text = builtins.readFile ./darklyrc;
              target = "${config.xdg.configHome}/darklyrc";
            };
            # Flatpak theming issue workarounds
            flatpak-font = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.inter}/share/fonts/opentype";
              target = "${config.xdg.dataHome}/fonts/inter";
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
              text = builtins.readFile ./klassyrc;
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
            wallpapers = {
              enable = true;
              recursive = true;
              source = ./wallpapers;
              target = "${config.home.homeDirectory}/Pictures/wallpapers";
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
          freetube = {
            settings = {
              baseTheme = "catppuccin${flavor-upper}";
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
              font = {
                family = "${mono-font}";
                pointSize = 14;
              };
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
                wallpaper = "${wallpaper}";
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
              wallpaper = "${wallpaper}";
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
