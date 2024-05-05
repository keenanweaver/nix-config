{ config, lib, username, pkgs, dotfiles, vars, ... }:
let
  bibata-sky-mocha = pkgs.stdenvNoCC.mkDerivation {
    pname = "bibata-sky-mocha";
    version = "master";

    src = pkgs.fetchurl {
      url = "https://github.com/keenanweaver/nix-config/raw/main/dotfiles/Bibata-Sky-Mocha.tar.gz";
      hash = "sha256-myH5uUUHQGmtF7uON2nLo2tr0taMbq8yZeU6AeSspqo=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/share/icons/Bibata-Sky-Mocha
      mv * $out/share/icons/Bibata-Sky-Mocha
    '';
  };
  accent-lower = "sky";
  accent-upper = "Sky";
  flavor-lower = "mocha";
  flavor-upper = "Mocha";
  cfg = config.catppuccinTheming;
  mono-font = "JetBrainsMono Nerd Font";
  sans-font = "IBM Plex Sans";
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
      flavour = "${flavor-lower}";
    };
    boot = {
      plymouth = {
        themePackages = with pkgs; [
          (catppuccin-plymouth.override {
            variant = "${flavor-lower}";
          })
        ];
        theme = "catppuccin-${flavor-lower}";
      };
    };
    console = {
      packages = with pkgs; [ terminus_font ];
    };
    environment = {
      systemPackages = with pkgs; [
        bibata-sky-mocha
        (catppuccin-gtk.override {
          size = "standard";
          accents = [ "${accent-lower}" ];
          variant = "${flavor-lower}";
          tweaks = [ "rimless" ];
        })
        (catppuccin-kde.override {
          accents = [ "${accent-lower}" ];
          flavour = [ "${flavor-lower}" ];
        })
        (catppuccin-papirus-folders.override {
          accent = "${accent-lower}";
          flavor = "${flavor-lower}";
        })
        (catppuccin-sddm.override {
          flavor = "${flavor-lower}";
          font = "${mono-font}";
          fontSize = "14";
          background = "${dotfiles}/wallpapers/layered-waves-haikei.png";
          loginBackground = true;
        })
      ];
    };
    services = {
      displayManager = {
        sddm = {
          extraPackages = [ bibata-sky-mocha ];
          settings = {
            Theme = {
              CursorTheme = "Bibata-${accent-upper}-${flavor-upper}";
            };
          };
          theme = "catppuccin-${flavor-lower}";
        };
      };
    };

    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      catppuccin = {
        enable = true;
        flavour = "${flavor-lower}";
      };

      colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

      fonts.fontconfig.enable = true;

      gtk = {
        catppuccin = {
          accent = "${accent-lower}";
        };
        cursorTheme = {
          name = lib.mkForce "Bibata-${accent-upper}-${flavor-upper}";
          package = lib.mkForce bibata-sky-mocha;
          size = 24;
        };
        font = {
          name = "${sans-font}";
          size = 13;
          package = pkgs.ibm-plex;
        };
        gtk3 = {
          extraConfig = {
            gtk-xft-antialias = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintslight";
            gtk-xft-rgba = "rgb";
          };
        };
        gtk4 = {
          extraConfig = {
            gtk-xft-antialias = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintslight";
            gtk-xft-rgba = "rgb";
          };
        };
        # Icon theming breaks in GTK4 apps
        /*         iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders.override {
            accent = "${accent-lower}";
            flavor = "${flavor-lower}";
          };
        }; */
      };
      home = {
        file = {
          catppuccin-armcord = {
            enable = true;
            text = ''
              @import url("https://catppuccin.github.io/discord/dist/catppuccin-${flavor-lower}-${accent-lower}.theme.css");
            '';
            target = ".var/app/xyz.armcord.ArmCord/config/ArmCord/themes/${flavor-lower}.theme.css";
          };
          # Flatpak theming issue workaround
          catppuccin-gtk = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.catppuccin-gtk.override { accents = [ "${accent-lower}" ]; variant = "${flavor-lower}";}}/share/themes/Catppuccin-${flavor-upper}-Standard-${accent-upper}-Dark";
            target = "${config.xdg.dataHome}/themes/Catppuccin-${flavor-upper}-Standard-${accent-upper}-Dark";
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
          catppuccin-krita = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/Catppuccin${flavor-upper}${accent-upper}.colors";
            target = ".var/app/org.kde.krita/data/krita/color-schemes/Catppuccin${flavor-upper}${accent-upper}.colors";
          };
          catppuccin-kvantum = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-kvantum}/src/Catppuccin-${flavor-upper}-${accent-upper}";
            target = "${config.xdg.configHome}/Kvantum/Catppuccin-${flavor-upper}-${accent-upper}-backup";
          };
          catppuccin-obs = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-obs}/themes";
            target = ".var/app/com.obsproject.Studio/config/obs-studio/themes/";
          };
          catppuccin-powershell = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-powershell}";
            target = "${config.xdg.dataHome}/powershell/Modules/Catppuccin";
          };
          cursor = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${bibata-sky-mocha}/share/icons/Bibata-${accent-upper}-${flavor-upper}";
            target = "${config.xdg.dataHome}/icons/Bibata-${accent-upper}-${flavor-upper}";
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
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; }}/share/fonts/truetype/NerdFonts";
            target = "${config.xdg.dataHome}/fonts/blex-mono";
          };
          /*           kde-kwin-scripts = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.local/share/kwin/scripts";
            target = "${config.xdg.dataHome}/kwin/scripts";
          }; */
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
          wallpapers = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wallpapers";
            target = "Pictures/wallpapers";
          };
          wayland-cursor-fix = {
            enable = true;
            text = ''
              [Icon Theme]
              Inherits=Bibata-${accent-upper}-${flavor-upper}
            '';
            target = "${config.xdg.dataHome}/icons/default/index.theme";
          };
        };
        packages = with pkgs; [
          bibata-sky-mocha
          gnome.adwaita-icon-theme
          hicolor-icon-theme
          vivid
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
              size = 14;
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
            main = {
              font = "${mono-font}:size=13";
            };
          };
        };
        fzf = {
          colors = {
            "bg+" = "#313244";
            "bg" = "#1e1e2e";
            "spinner" = "#f5e0dc";
            "hl" = "#f38ba8";
            "fg" = "#cdd6f4";
            "header" = "#f38ba8";
            "info" = "#cba6f7";
            "pointer" = "#f5e0dc";
            "marker" = "#f5e0dc";
            "fg+" = "#cdd6f4";
            "prompt" = "#cba6f7";
            "hl+" = "#f38ba8";
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
            catppuccin_transparent =
              {
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
              flavour = "${flavor-lower}";
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
          workspace = {
            colorScheme = "Catppuccin${flavor-upper}${accent-upper}";
            cursorTheme = "Bibata-${accent-upper}-${flavor-upper}";
            iconTheme = "Papirus-Dark";
            lookAndFeel = "Catppuccin-${flavor-upper}-${accent-upper}";
            theme = "default";
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
            "Gtk/CursorThemeSize" = 32;
            "Gtk/CursorThemeName" = "Bibata-${accent-upper}-${flavor-upper}";
            "Gtk/FontName" = "${sans-font},  13";
            "Net/IconThemeName" = "Papirus-Dark";
            "Net/ThemeName" = "Catppuccin-${flavor-upper}-Standard-${accent-upper}-Dark";
          };
        };
      };
      wayland.windowManager.hyprland = { };
      /*       xdg.configFile = {
        #https://github.com/catppuccin/gtk/pull/151/files
        "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      }; */
      xresources = {
        properties = {
          "Xcursor.size" = 24;
          "Xcursor.theme" = "Bibata-${accent-upper}-${flavor-upper}";
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
