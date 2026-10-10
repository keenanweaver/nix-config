{ self, inputs, ... }:
let
  GTK-THEME = "Breeze-Dark";
  accent-lower = "lavender";
  accent-upper = "Lavender";
  catppuccinCommon = {
    enable = true;
    accent = accent-lower;
    autoEnable = true;
  };
  cursor-theme = "catppuccin-${flavor-accent}-cursors";
  flavor-accent = "${flavor-lower}-${accent-lower}";
  flavor-lower = "mocha";
  flavor-upper = "Mocha";
  icon-theme = "Papirus-Dark";
  mono-font = "Maple Mono Normal NF";
  mono-size = 14;
  sans-font = "Inter";
  wallpaper = ../../assets/theming/wallpapers/wallhaven-2kpexy.jpg;
in
{
  flake = {
    lib.fonts.monospace = {
      family = mono-font;
      size = mono-size;
    };
    modules = {
      homeManager = {
        catppuccin =
          {
            lib,
            config,
            pkgs,
            ...
          }:
          let
            inherit (config.catppuccin) sources;
          in
          {
            imports = [ inputs.catppuccin.homeModules.catppuccin ];
            catppuccin = catppuccinCommon // {
              cursors = {
                enable = true;
                accent = accent-lower;
              };
              mangohud.enable = false;
              micro.transparent = true;
              nvim.enable = false;
              vscodium.profiles.default.accent = accent-lower;
              yazi.enable = false;
            };
            dconf.settings = {
              "org/gnome/desktop/interface".color-scheme = "prefer-dark";
              "org/gnome/desktop/wm/preferences".button-layout = "icon:minimize,maximize,close";
            };
            gtk = {
              enable = true;
              cursorTheme = {
                name = cursor-theme;
                size = 24;
              };
              font = {
                package = pkgs.inter;
                name = sans-font;
                size = 12;
              };
              gtk2.force = true;
              gtk3.extraConfig = {
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
              gtk4.extraConfig = {
                gtk-decoration-layout = "icon:minimize,maximize,close";
                gtk-enable-animations = true;
                gtk-font-rendering = "manual";
                gtk-hint-font-metrics = true;
                gtk-primary-button-warps-slider = true;
                gtk-sound-theme-name = "ocean";
                gtk-theme-name = "Catppuccin-GTK-${accent-upper}-Dark";
                gtk-xft-antialias = 1;
                gtk-xft-hinting = 1;
                gtk-xft-hintstyle = "hintslight";
                gtk-xft-rgba = "rgb";
              };
              theme.name = "Adwaita";
            };
            home = {
              file.".var/app/com.obsproject.Studio/config/obs-studio/themes" = {
                recursive = true;
                source = "${inputs.catppuccin-obs}/themes";
              };
              packages = with pkgs; [
                (magnetic-catppuccin-gtk.override {
                  accent = [ accent-lower ];
                  shade = "dark";
                })
                ## GNOME
                adwaita-icon-theme
                gnome-settings-daemon
                gsettings-desktop-schemas
                gsettings-qt
                hicolor-icon-theme
              ];
              pointerCursor.enable = true;
              sessionVariables = {
                GTK_USE_PORTAL = "1";
                LS_COLORS = "$(${lib.getExe pkgs.vivid} generate catppuccin-${flavor-lower})";
                XCURSOR_NAME = cursor-theme;
                XCURSOR_SIZE = "24";
              };
            };
            programs = {
              bat.config.pager = "less -FR";
              btop.settings.theme_background = false;
              freetube.settings.baseTheme = "catppuccin${flavor-upper}";
              halloy.settings.font = {
                family = mono-font;
                size = 20;
              };
              helix = {
                settings.theme = lib.mkForce "catppuccin_transparent";
                themes.catppuccin_transparent = {
                  inherits = "catppuccin-${flavor-lower}";
                  "ui.background" = "none";
                };
              };
              lazygit.settings.gui = {
                border = "single";
                mainPanelSplitMode = "vertical";
                nerdFontsVersion = "3";
                scrollHeight = 10;
                scrollOffMargin = 4;
                showFileTree = false;
                sidePanelWidth = 0.3333;
              };
            };
            xdg = {
              configFile = {
                Kvantum = {
                  recursive = true;
                  source = ../../assets/theming/Kvantum;
                };
                "gtk-3.0" = {
                  recursive = true;
                  source = ../../assets/theming/gtk-3.0;
                };
                "gtk-4.0/gtk.css".text = builtins.readFile ../../assets/theming/gtk-4.0/gtk.css;
                "powershell/Microsoft.PowerShell_profile.ps1".text = ''
                  Import-Module Catppuccin
                  $Flavor = $Catppuccin['${flavor-upper}']
                '';
                "yazi/Catppuccin-${flavor-lower}.tmTheme".source =
                  "${sources.bat}/Catppuccin ${flavor-upper}.tmTheme";
                "yazi/theme.toml".text =
                  lib.replaceStrings [ ''overall = { bg = "#1e1e2e" }'' ] [ ''overall = { bg = "reset" }'' ]
                    (builtins.readFile "${sources.yazi}/${flavor-lower}/catppuccin-${flavor-accent}.toml");
              };
              dataFile = {
                # Flatpak theming issue workarounds
                "fonts/inter".source = "${pkgs.inter}/share/fonts/opentype";
                "krita/color-schemes/Catppuccin${flavor-upper}${accent-upper}.colors".source = "${
                  pkgs.catppuccin-kde.override {
                    accents = [ accent-lower ];
                    flavour = [ flavor-lower ];
                  }
                }/share/color-schemes/Catppuccin${flavor-upper}${accent-upper}.colors";
                "powershell/Modules/Catppuccin".source = inputs.catppuccin-powershell;
                "themes/${GTK-THEME}".source = "${pkgs.kdePackages.breeze-gtk}/share/themes/${GTK-THEME}";
              };
            };
          };
        plasma-manager =
          {
            lib,
            osConfig,
            ...
          }:
          {
            programs = {
              kate.editor.font = {
                family = mono-font;
                pointSize = mono-size;
              };
              konsole.profiles = {
                "${osConfig.my.user}" = {
                  colorScheme = "catppuccin-${flavor-lower}-transparent";
                  font = {
                    name = mono-font;
                    size = mono-size;
                  };
                };
              };
              plasma = {
                configFile.kdeglobals.KDE.widgetStyle = "Breeze";
                fonts = {
                  fixedWidth = {
                    family = mono-font;
                    pointSize = mono-size;
                  };
                  general = {
                    family = sans-font;
                    pointSize = 12;
                  };
                  menu = {
                    family = sans-font;
                    pointSize = 12;
                  };
                  small = {
                    family = sans-font;
                    pointSize = 12;
                  };
                  toolbar = {
                    family = sans-font;
                    pointSize = 12;
                  };
                  windowTitle = {
                    family = sans-font;
                    pointSize = 12;
                  };
                };
                kscreenlocker.appearance.wallpaper = "${wallpaper}";
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
                    theme = cursor-theme;
                  };
                  # Icons
                  iconTheme = icon-theme;
                  # System sounds
                  soundTheme = "ocean";
                  # Splash Screen
                  splashScreen.theme = lib.mkDefault "Catppuccin-${flavor-upper}-${accent-upper}";
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
            xdg = {
              configFile."klassy/klassyrc".text = ''
                [Global]
                LookAndFeelSet=Catppuccin-${flavor-upper}-${accent-upper}

                [Style]
                MenuOpacity=70

                [Windeco]
                AnimationsSpeedRelativeSystem=8

                [SystemIconGeneration]
                KlassyDarkIconThemeInherits=Papirus-Dark
                KlassyIconThemeInherits=Papirus
              '';
              dataFile = {
                "konsole/catppuccin-${flavor-lower}-transparent.colorscheme".text =
                  builtins.readFile ../../assets/theming/catppuccin-${flavor-lower}-transparent.colorscheme;
                "konsole/catppuccin-${flavor-lower}.colorscheme".source =
                  "${inputs.catppuccin-konsole}/themes/catppuccin-${flavor-lower}.colorscheme";
              };
            };
          };
        profile-desktop.programs.lazyvim.plugins.colorscheme = ''
          return {
            {
              "catppuccin/nvim",
              name = "catppuccin",
              lazy = true,
            },
            {
              "LazyVim/LazyVim",
              opts = {
                colorscheme = function()
                  require("catppuccin").setup({
                    flavour = "${flavor-lower}",
                    transparent_background = true,
                    float = {
                      transparent = true,
                    },
                  })
                  vim.cmd.colorscheme("catppuccin")
                end,
              },
            },
          }
        '';
        profile-gaming = {
          home.file."Games/Heroic/catppuccin-${flavor-accent}.css".source =
            "${inputs.catppuccin-heroic}/themes/catppuccin-${flavor-accent}.css";
          services.flatpak.overrides."com.fightcade.Fightcade".Environment.GTK_THEME = GTK-THEME;
        };
      };
      nixos = {
        catppuccin =
          { ... }:
          {
            imports = [ inputs.catppuccin.nixosModules.catppuccin ];
            boot.kernelParams = [ "fbcon=font:TER16x32" ];
            catppuccin = catppuccinCommon // {
              plymouth.enable = false;
            };
            home-manager.sharedModules = [ self.modules.homeManager.catppuccin ];
            nix.settings = {
              extra-substituters = [
                "https://catppuccin.cachix.org"
              ];
              extra-trusted-public-keys = [
                "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
              ];
            };
            programs.dconf.enable = true;
          };
        kde =
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [
              (catppuccin-kde.override {
                accents = [ accent-lower ];
                flavour = [ flavor-lower ];
              })
              (catppuccin-papirus-folders.override {
                accent = accent-lower;
                flavor = flavor-lower;
              })
              darkly
              klassy
              plasma-panel-colorizer
              utterly-round-plasma-style
            ];
          };
      };
    };
  };
  flake-file.inputs = {
    catppuccin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:catppuccin/nix";
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
  };
}
