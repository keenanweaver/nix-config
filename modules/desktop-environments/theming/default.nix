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
  sans-font = "IBM Plex Sans";
  serif-font = "IBM Plex Serif";
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
        GTK_THEME = "catppuccin-${flavor-lower}-${accent-lower}-standard+normal";
      };
      systemPackages = with pkgs; [
        # Needed for some GTK3 apps. For some reason the catppuccin nix/gtk module doesn't cover these
        (catppuccin-gtk.override {
          accents = [ "${accent-lower}" ];
          variant = "${flavor-lower}";
          size = "standard";
          tweaks = [ "normal" ];
        })
        (catppuccin-kde.override {
          accents = [ "${accent-lower}" ];
          flavour = [ "${flavor-lower}" ];
        })
        (catppuccin-papirus-folders.override {
          accent = "${accent-lower}";
          flavor = "${flavor-lower}";
        })
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
              CursorTheme = "breeze_cursors";
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
           name = "breeze_cursors";
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

        fonts.fontconfig.enable = true;

        gtk = {
          enable = true;
          catppuccin = {
            enable = false;
            cursor.enable = false;
            size = "standard";
            tweaks = [ "normal" ];
          };
          cursorTheme = {
            name = lib.mkDefault "breeze_cursors";
            size = 24;
          };
          font = {
            name = "${sans-font}";
            size = 13;
            package = pkgs.ibm-plex;
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
        };
        home = {
          file = {
            # Flatpak theming issue workarounds
            catppuccin-gtk = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${
                pkgs.catppuccin-gtk.override {
                  accents = [ "${accent-lower}" ];
                  variant = "${flavor-lower}";
                  size = "standard";
                  tweaks = [ "normal" ];
                }
              }/share/themes/catppuccin-${flavor-lower}-${accent-lower}-standard+normal";
              target = "${config.xdg.dataHome}/themes/catppuccin-${flavor-lower}-${accent-lower}-standard+normal";
            };
            catppuccin-armcord = {
              enable = true;
              text = ''
                @import url("https://catppuccin.github.io/discord/dist/catppuccin-${flavor-lower}-${accent-lower}.theme.css");
              '';
              target = ".var/app/xyz.armcord.ArmCord/config/ArmCord/themes/${flavor-lower}.theme.css";
            };
            catppuccin-ghostwriter = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-ghostwriter}/colours/Catppuccin-Latte-${flavor-upper}-${accent-upper}.json";
              target = "${config.xdg.dataHome}/ghostwriter/themes/Catppuccin-Latte-${flavor-upper}-${accent-upper}.json";
            };
            catppuccin-halloy = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-halloy}/catppuccin-${flavor-lower}.yaml";
              target = ".var/app/org.squidowl.halloy/config/halloy/themes/catppuccin-${flavor-lower}.yaml";
            };
            catppuccin-heroic = {
              enable = vars.gaming;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-heroic}/themes/catppuccin-${flavor-lower}.css";
              target = "Games/Heroic/catppuccin-${flavor-lower}.css";
            };
            catppuccin-konsole = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/Catppuccin-${flavor-upper}.colorscheme";
              target = "${config.xdg.dataHome}/konsole/Catppuccin-${flavor-upper}.colorscheme";
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
            ibm-plex = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${pkgs.ibm-plex}/share/fonts/opentype";
              target = "${config.xdg.dataHome}/fonts/ibm-plex";
            };
            ibm-blex = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${
                pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; }
              }/share/fonts/truetype/NerdFonts";
              target = "${config.xdg.dataHome}/fonts/blex-mono";
            };
            /*
              kde-kwin-scripts = {
                enable = true;
                recursive = true;
                source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.local/share/kwin/scripts";
                target = "${config.xdg.dataHome}/kwin/scripts";
              };
            */
            kde-plasmoid-tiled-menu = {
              enable = false;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${inputs.kde-plasmoid-tiled-menu}/package";
              target = "${config.xdg.dataHome}/plasma/plasmoids/com.github.zren.tiledmenu";
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
                Inherits=breeze_cursors
              '';
              target = "${config.xdg.dataHome}/icons/default/index.theme";
            };
          };
          packages = with pkgs; [
            /*
              (catppuccin-gtk.override {
                         accents = [ "${accent-lower}" ];
                         variant = "${flavor-lower}";
                         size = "standard";
                         tweaks = [ "normal" ];
                       })
            */
            hicolor-icon-theme
            vivid
            ## GNOME
            #adw-gtk3
            gnome.adwaita-icon-theme
            gnome.gnome-settings-daemon
            gsettings-desktop-schemas
            gsettings-qt
          ];
          sessionVariables = {
            GSETTINGS_BACKEND = "keyfile";
            GTK_USE_PORTAL = "1";
            LS_COLORS = "$(vivid generate catppuccin-${flavor-lower})";
            MICRO_TRUECOLOR = "1";
            NNN_COLORS = "#04020301;4231";
            NNN_FCOLORS = "030304020705050801060301";
            XCURSOR_SIZE = "24";
          };
        };
        programs = {
          alacritty = {
            settings = {
              colors = {
                draw_bold_text_with_bright_colors = true;
              };
              env = {
                TERM = "xterm-256color";
              };
              font = {
                size = 13;
              };
              window = {
                opacity = 0.7;
                blur = true;
              };
            };
          };
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
                font = "${mono-font}:size=13";
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
          konsole = {
            profiles = {
              "${username}" = {
                colorScheme = "Catppuccin-${flavor-upper}";
                font = {
                  name = "${mono-font}";
                  size = 13;
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
              # Window decorations
              "kdeglobals"."KDE"."widgetStyle" = "Breeze";
              kwinrc = {
                "org.kde.kdecoration2"."library" = "org.kde.breeze";
                "org.kde.kdecoration2"."theme" = "Breeze";
              };
            };
            fonts = {
              general = {
                family = "${sans-font}";
                pointSize = 13;
              };
              fixedWidth = {
                family = "${mono-font}";
                pointSize = 13;
              };
              small = {
                family = "${sans-font}";
                pointSize = 12;
              };
              toolbar = {
                family = "${sans-font}";
                pointSize = 13;
              };
              menu = {
                family = "${sans-font}";
                pointSize = 13;
              };
              windowTitle = {
                family = "${sans-font}";
                pointSize = 13;
              };
            };
            workspace = {
              colorScheme = "Catppuccin${flavor-upper}${accent-upper}";
              cursor.theme = "breeze_cursors";
              iconTheme = "Papirus-Dark";
              #lookAndFeel = "Catppuccin-${flavor-upper}-${accent-upper}";
              theme = "default";
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
        };
        services = {
          xsettingsd = {
            settings = {
              "Gtk/CursorThemeSize" = 24;
              "Gtk/CursorThemeName" = "breeze_cursors";
              "Gtk/FontName" = "${sans-font},  13";
              "Net/IconThemeName" = "Papirus-Dark";
              "Net/ThemeName" = "catppuccin-${flavor-lower}-${accent-lower}-standard+normal";
            };
          };
        };

        xresources = {
          properties = {
            "Xcursor.size" = 24;
            "Xcursor.theme" = "breeze_cursors";
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
