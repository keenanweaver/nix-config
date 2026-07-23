{ inputs, ... }:
let
  GTK-THEME = "Breeze-Dark";
  accent-lower = "lavender";
  accent-upper = "Lavender";
  cursor-theme = "catppuccin-${flavor-lower}-${accent-lower}-cursors";
  flavor-lower = "mocha";
  flavor-upper = "Mocha";
  icon-theme = "Papirus-Dark";
  mkWallpaper =
    pkgs:
    pkgs.fetchurl {
      hash = "sha256-vSzbsrAg6EalV5FzvHPQRS1qdhjJpDSjda4M+s8ACU4=";
      url = "https://w.wallhaven.cc/full/2k/wallhaven-2kpexy.jpg";
    };
  mono-font = "Maple Mono Normal NF";
  sans-font = "Inter";
in
{
  flake.modules = {
    homeManager.catppuccin =
      {
        config,
        lib,
        pkgs,
        osConfig,
        ...
      }:
      let
        sans-font-pkg = pkgs.local.inter;
        wallpaper = mkWallpaper pkgs;
      in
      {
        imports = [
          inputs.catppuccin.homeModules.catppuccin
          inputs.nvf.homeManagerModules.default
          inputs.plasma-manager.homeModules.plasma-manager
        ];
        catppuccin = {
          enable = true;
          accent = "${accent-lower}";
          autoEnable = true;
          cache.enable = false;
          cursors = {
            enable = true;
            accent = "${accent-lower}";
          };
          flavor = "${flavor-lower}";
          lazygit = {
            accent = "${accent-lower}";
          };
          mangohud.enable = false;
          micro = {
            transparent = true;
          };
          vscodium = {
            profiles.default = {
              accent = "${accent-lower}";
            };
          };
          yazi = {
            accent = "${accent-lower}";
          };
        };
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
        gtk = {
          enable = true;
          cursorTheme = {
            name = "${cursor-theme}";
            size = 24;
          };
          font = {
            package = sans-font-pkg;
            name = "${sans-font}";
            size = 12;
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
              gtk-font-rendering = "manual";
              gtk-hint-font-metrics = true;
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
            catppuccin-ghostwriter = {
              enable = true;
              source = "${inputs.catppuccin-ghostwriter}/themes/catppuccin-${flavor-lower}-${accent-lower}.json";
              target = "${config.xdg.dataHome}/ghostwriter/themes/catppuccin-${flavor-lower}-${accent-lower}.json";
            };
            catppuccin-gtk = {
              enable = true;
              source = "${pkgs.kdePackages.breeze-gtk}/share/themes/${GTK-THEME}";
              target = "${config.xdg.dataHome}/themes/${GTK-THEME}";
            };
            catppuccin-konsole = {
              enable = true;
              source = "${inputs.catppuccin-konsole}/themes/catppuccin-${flavor-lower}.colorscheme";
              target = "${config.xdg.dataHome}/konsole/catppuccin-${flavor-lower}.colorscheme";
            };
            catppuccin-konsole-transparent = {
              enable = true;
              target = "${config.xdg.dataHome}/konsole/catppuccin-${flavor-lower}-transparent.colorscheme";
              text = builtins.readFile ../assets/theming/catppuccin-mocha-transparent.colorscheme;
            };
            catppuccin-krita = {
              enable = true;
              target = "${config.xdg.dataHome}/krita/color-schemes/Catppuccin${flavor-upper}${accent-upper}.colors";
              text = builtins.readFile ../assets/theming/krita/CatppuccinMochaLavender.colors;
            };
            catppuccin-obs-flatpak = {
              enable = true;
              recursive = true;
              source = "${inputs.catppuccin-obs}/themes";
              target = ".var/app/com.obsproject.Studio/config/obs-studio/themes";
            };
            catppuccin-powershell = {
              enable = true;
              source = "${inputs.catppuccin-powershell}";
              target = "${config.xdg.dataHome}/powershell/Modules/Catppuccin";
            };
            cursor-theme-default = {
              enable = false;
              target = "${config.xdg.dataHome}/icons/default/index.theme";
              text = ''
                [Icon Theme]
                Inherits=${cursor-theme}
              '';
            };
            darkly-config = {
              enable = false;
              target = "${config.xdg.configHome}/darklyrc";
              text = builtins.readFile ../assets/theming/darklyrc;
            };
            # Flatpak theming issue workarounds
            flatpak-font = {
              enable = true;
              source = "${pkgs.local.inter}/share/fonts/opentype";
              target = "${config.xdg.dataHome}/fonts/inter";
            };
            gtk3-config-gtk = {
              enable = true;
              target = "${config.xdg.configHome}/gtk-3.0/gtk.css";
              text = builtins.readFile ../assets/theming/gtk-3.0/gtk.css;
            };
            gtk4-config-gtk = {
              enable = true;
              target = "${config.xdg.configHome}/gtk-4.0/gtk.css";
              text = builtins.readFile ../assets/theming/gtk-4.0/gtk.css;
            };
            klassy-config = {
              enable = true;
              target = "${config.xdg.configHome}/klassy/klassyrc";
              text = builtins.readFile ../assets/theming/klassyrc;
            };
            kvantum-config = {
              enable = true;
              recursive = true;
              source = ../assets/theming/Kvantum;
              target = "${config.xdg.configHome}/Kvantum";
            };
            powershell-profile = {
              enable = true;
              target = "${config.xdg.configHome}/powershell/Microsoft.PowerShell_profile.ps1";
              text = ''
                Import-Module Catppuccin
                $Flavor = $Catppuccin['${flavor-upper}']
              '';
            };
            wallpapers = {
              enable = true;
              recursive = true;
              source = ../assets/theming/wallpapers;
              target = "${config.home.homeDirectory}/Pictures/wallpapers";
            };
          };
          packages = with pkgs; [
            hicolor-icon-theme
            ## GNOME
            adwaita-icon-theme
            gnome-settings-daemon
            gsettings-desktop-schemas
            gsettings-qt
          ];
          sessionVariables = {
            GSETTINGS_BACKEND = "keyfile";
            GTK_USE_PORTAL = "1";
            LS_COLORS = "$(${lib.getExe pkgs.vivid} generate catppuccin-${flavor-lower})";
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
          halloy = {
            settings = {
              font = {
                family = "${mono-font}";
                size = 20;
              };
            };
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
              "${osConfig.my.user}" = {
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
          lazyvim = {
            plugins = {
              colorscheme = ''
                return {
                  "catppuccin/nvim",
                  opts = { flavour = "mocha", transparent_background = true },
                  {
                    "LazyVim/LazyVim",
                    opts = {
                      colorscheme = "catppuccin",
                    },
                  }
                }
              '';
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
              "kdeglobals"."KDE"."widgetStyle" = "Klassy";
            };
            fonts = {
              fixedWidth = {
                family = "${mono-font}";
                pointSize = 14;
              };
              general = {
                family = "${sans-font}";
                pointSize = 12;
              };
              menu = {
                family = "${sans-font}";
                pointSize = 12;
              };
              small = {
                family = "${sans-font}";
                pointSize = 12;
              };
              toolbar = {
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
              # Cursors
              # plasma-apply-cursortheme --list-themes
              cursor = {
                size = 24;
                theme = "${cursor-theme}";
              };
              # Icons
              iconTheme = "${icon-theme}";
              # System sounds
              soundTheme = "ocean";
              # Splash Screen
              splashScreen.theme = "Catppuccin-${flavor-upper}-${accent-upper}";
              # Plasma Style
              # plasma-apply-desktoptheme --list-themes
              theme = "Utterly-Round";
              # Wallpaper
              wallpaper = "${wallpaper}";
              # Window decorations
              windowDecorations = {
                library = "org.kde.klassy";
                theme = "Klassy";
              };
            };
          };
        };
        services = {
          flatpak = {
            overrides = {
              "app.zen_browser.zen" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
              "com.fightcade.Fightcade" = {
                Environment = {
                  GTK_THEME = "${GTK-THEME}";
                };
              };
            };
          };
          xsettingsd = {
            settings = {
              "Gtk/CursorThemeName" = "${cursor-theme}";
              "Gtk/CursorThemeSize" = 24;
              "Gtk/FontName" = "${sans-font},  12";
              "Net/IconThemeName" = "${icon-theme}";
              "Net/ThemeName" = "${GTK-THEME}";
            };
          };
        };
        xresources = {
          properties = {
            # Catppuccin
            "*background" = "#1E1E2E";
            "*color0" = "#45475A";
            "*color1" = "#F38BA8";
            "*color10" = "#A6E3A1";
            "*color11" = "#F9E2AF";
            "*color12" = "#89B4FA";
            "*color13" = "#F5C2E7";
            "*color14" = "#94E2D5";
            "*color15" = "#A6ADC8";
            "*color2" = "#A6E3A1";
            "*color3" = "#F9E2AF";
            "*color4" = "#89B4FA";
            "*color5" = "#F5C2E7";
            "*color6" = "#94E2D5";
            "*color7" = "#BAC2DE";
            "*color8" = "#585B70";
            "*color9" = "#F38BA8";
            "*foreground" = "#CDD6F4";
            "Xcursor.size" = 24;
            "Xcursor.theme" = "${cursor-theme}";
            "Xft.antialias" = 1;
            "Xft.autohint" = 1;
            "Xft.hinting" = 1;
            "Xft.hintstyle" = "hintfull";
            "Xft.lcdfilter" = "lcddefault";
            "Xft.rgba" = "rgb";
          };
        };
      };
    homeManager.gaming-profile = {
      home.file.catppuccin-heroic = {
        enable = true;
        source = "${inputs.catppuccin-heroic}/themes/catppuccin-${flavor-lower}-${accent-lower}.css";
        target = "Games/Heroic/catppuccin-${flavor-lower}-${accent-lower}.css";
      };
    };
    nixos.catppuccin = { pkgs, ... }: {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];
      catppuccin =
        let
          wallpaper = mkWallpaper pkgs;
        in
        {
          enable = true;
          accent = "${accent-lower}";
          autoEnable = true;
          cache.enable = false;
          flavor = "${flavor-lower}";
          sddm = {
            background = "${wallpaper}";
            font = "${mono-font}";
            fontSize = "11";
          };
        };
      environment.systemPackages = with pkgs; [
        (catppuccin-kde.override {
          accents = [ "${accent-lower}" ];
          flavour = [ "${flavor-lower}" ];
        })
        (catppuccin-papirus-folders.override {
          accent = "${accent-lower}";
          flavor = "${flavor-lower}";
        })
        inputs.kwin-effects-glass.packages.${stdenv.hostPlatform.system}.default
        klassy
        kdePackages.qtstyleplugin-kvantum
        plasma-panel-colorizer
        utterly-round-plasma-style
      ];
      nix.settings = {
        extra-substituters = [
          "https://catppuccin.cachix.org"
        ];
        extra-trusted-public-keys = [
          "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        ];
      };
      programs.dconf.enable = true;
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
    };
  };
  flake-file.inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    catppuccin-ghostwriter = {
      flake = false;
      url = "github:catppuccin/ghostwriter";
    };
    catppuccin-heroic = {
      flake = false;
      url = "github:catppuccin/heroic";
    };
    catppuccin-konsole = {
      flake = false;
      url = "github:catppuccin/konsole";
    };
    catppuccin-obs = {
      flake = false;
      url = "github:catppuccin/obs";
    };
    catppuccin-powershell = {
      flake = false;
      url = "github:catppuccin/powershell";
    };
    catppuccin-xresources = {
      flake = false;
      url = "github:catppuccin/xresources";
    };
    catppuccin-zen = {
      flake = false;
      url = "github:catppuccin/zen-browser";
    };
  };
}
