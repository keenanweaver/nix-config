{ inputs, home-manager, lib, config, username, pkgs, dotfiles, vars, ... }: with lib;
let
  bibata-sky-mocha = pkgs.stdenvNoCC.mkDerivation {
    pname = "bibata-sky-mocha";
    version = "master";

    src = pkgs.fetchurl {
      url = "https://codeberg.org/Keenan/nix-config/raw/branch/main/dotfiles/Bibata-Sky-Mocha.tar.gz";
      hash = "sha256-CEwI9UsMkBLjkwxkX9z4xK5DsxIS8rzC5n4cdaMR6jk=";
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
  catppuccin-accent-lower = "sky";
  catppuccin-accent-upper = "Sky";
  cfg = config.catppuccinTheming;
  mono-font = "JetBrainsMono Nerd Font";
  sans-font = "IBM Plex Sans";
in
{
  options = {
    catppuccinTheming = {
      enable = mkEnableOption "Enable catppuccinTheming in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    catppuccin.flavour = "mocha";
    console.catppuccin.enable = true;
    boot = {
      plymouth = {
        themePackages = with pkgs; [
          (catppuccin-plymouth.override {
            variant = "mocha";
          })
        ];
        theme = "catppuccin-mocha";
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
          accents = [ "${catppuccin-accent-lower}" ];
          variant = "mocha";
          tweaks = [ "rimless" ];
        })
        (catppuccin-kde.override {
          accents = [ "${catppuccin-accent-lower}" ];
          flavour = [ "mocha" ];
        })
        (catppuccin-papirus-folders.override {
          accent = "${catppuccin-accent-lower}";
          flavor = "mocha";
        })
        (catppuccin-sddm.override {
          flavor = "mocha";
          font = "JetBrainsMono Nerd Font";
          fontSize = "14";
          background = "${dotfiles}/wallpapers/layered-waves-haikei.png";
          loginBackground = true;
        })
      ];
    };
    services = {
      displayManager = {
        sddm = {
          settings = {
            Theme = {
              CursorTheme = "Bibata-${catppuccin-accent-upper}-Mocha";
            };
          };
          theme = "catppuccin-mocha";
        };
      };
    };

    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      catppuccin = {
        #enable = true; # Wait for https://github.com/catppuccin/nix/pull/124
        flavour = "mocha";
      };
      colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

      fonts.fontconfig.enable = true;

      gtk = {
        catppuccin = {
          enable = true;
          accent = "sky";
        };
        cursorTheme = {
          name = "Bibata-${catppuccin-accent-upper}-Mocha";
          package = bibata-sky-mocha;
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
          #extraCss = builtins.readFile "${dotfiles}/.config/gtk-3.0/colors.css";
        };
        gtk4 = {
          extraConfig = {
            gtk-xft-antialias = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintslight";
            gtk-xft-rgba = "rgb";
          };
          #extraCss = builtins.readFile "${dotfiles}/.config/gtk-4.0/colors.css";
        };
        /*         theme = {
          name = "Catppuccin-Mocha-Standard-${catppuccin-accent-upper}-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "${catppuccin-accent-lower}" ];
            size = "standard";
            tweaks = [ "rimless" ];
            variant = "mocha";
          };
        }; */
        # Icon theming breaks in GTK4 apps
        /*     iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "${catppuccin-accent-lower}";
        flavor = "mocha";
      };
        }; */
      };
      home = {
        file = {
          # https://github.com/rice-cracker-dev/nixos-config/blob/main/modules/home-manager/theme/default.nix
          "${config.xdg.configHome}/colorScheme/style.scss".text = with config.colorScheme.palette; ''
            @define-color base00 #${base00};
            @define-color base01 #${base01};
            @define-color base02 #${base02};
            @define-color base03 #${base03};
            @define-color base04 #${base04};
            @define-color base05 #${base05};
            @define-color base06 #${base06};
            @define-color base07 #${base07};
            @define-color base08 #${base08};
            @define-color base09 #${base09};
            @define-color base0A #${base0A};
            @define-color base0B #${base0B};
            @define-color base0C #${base0C};
            @define-color base0D #${base0D};
            @define-color base0E #${base0E};
            @define-color base0F #${base0F};
          '';
          catppuccin-armcord = {
            enable = true;
            recursive = false;
            text = ''
              @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-${catppuccin-accent-lower}.theme.css");
            '';
            target = ".var/app/xyz.armcord.ArmCord/config/ArmCord/themes/mocha.theme.css";
          };
          /*       catppuccin-btop = {
        enable = true;
        recursive = false;
        source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-btop}/themes/catppuccin_mocha.theme";
        target = "${config.xdg.configHome}/btop/themes/catppuccin_mocha.theme";
      };
      catppuccin-delta = {
        enable = true;
        recursive = false;
        source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-delta}/themes/mocha.gitconfig";
        target = "${config.xdg.configHome}/git/mocha.gitconfig";
          }; */
          # Flatpak theming issue workaround
          catppuccin-gtk = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.catppuccin-gtk.override { accents = [ "${catppuccin-accent-lower}" ]; variant = "mocha";}}/share/themes/Catppuccin-Mocha-Standard-${catppuccin-accent-upper}-Dark";
            target = "${config.xdg.dataHome}/themes/Catppuccin-Mocha-Standard-${catppuccin-accent-upper}-Dark";
          };
          catppuccin-ghostwriter = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-ghostwriter}/colours/Catppuccin-Latte-Mocha-${catppuccin-accent-upper}.json";
            target = "${config.xdg.dataHome}/ghostwriter/themes/Catppuccin-Latte-Mocha-${catppuccin-accent-upper}.json";
          };
          catppuccin-halloy = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-halloy}/catppuccin-mocha.yaml";
            target = ".var/app/org.squidowl.halloy/config/halloy/themes/catppuccin-mocha.yaml";
          };
          /*       catppuccin-helix = {
        enable = true;
        recursive = false;
        source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-helix}/themes/default/catppuccin_mocha.toml";
        target = "${config.xdg.configHome}/helix/themes/catppuccin_mocha.toml";
          }; */
          catppuccin-heroic = {
            enable = vars.gaming;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-heroic}/themes/catppuccin-mocha.css";
            target = "Games/Heroic/catppuccin-mocha.css";
          };
          /*       catppuccin-hyprland = {
        enable = true;
        recursive = false;
        source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-hyprland}/themes/mocha.conf";
        target = "${config.xdg.configHome}/hypr/themes/mocha.conf";
          }; */
          catppuccin-konsole = {
            enable = true;
            recursive = false;
            source =
              config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/Catppuccin-Mocha.colorscheme";
            target = "${config.xdg.dataHome}/konsole/Catppuccin-Mocha.colorscheme";
          };
          catppuccin-krita = {
            enable = true;
            recursive = false;
            source =
              config.lib.file.mkOutOfStoreSymlink "${dotfiles}/CatppuccinMocha${catppuccin-accent-upper}.colors";
            target = ".var/app/org.kde.krita/data/krita/color-schemes/CatppuccinMocha${catppuccin-accent-upper}.colors";
          };
          catppuccin-kvantum = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-kvantum}/src/Catppuccin-Mocha-${catppuccin-accent-upper}";
            target = "${config.xdg.configHome}/Kvantum/Catppuccin-Mocha-${catppuccin-accent-upper}-backup";
          };
          /*       catppuccin-micro = {
        enable = true;
        recursive = false;
        source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-micro}/src/catppuccin-mocha.micro";
        target = "${config.xdg.configHome}/micro/colorschemes/catppuccin-mocha.micro";
          }; */
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
          /*           catppuccin-yazi = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-yazi}/themes/mocha.toml";
            target = "${config.xdg.configHome}/yazi/theme.toml";
          }; */
          catppuccin-yazi-sh = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
            target = "${config.xdg.configHome}/yazi/Catppuccin-mocha.tmTheme";
          };
          cursor = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${bibata-sky-mocha}/share/icons/Bibata-${catppuccin-accent-upper}-Mocha";
            target = "${config.xdg.dataHome}/icons/Bibata-${catppuccin-accent-upper}-Mocha";
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
          kde-kwin-scripts = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.local/share/kwin/scripts";
            target = "${config.xdg.dataHome}/kwin/scripts";
          };
          kde-plasmoid-tiled-menu = {
            enable = false;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.kde-plasmoid-tiled-menu}/package";
            target = "${config.xdg.dataHome}/plasma/plasmoids/com.github.zren.tiledmenu";
          };
          wallpapers = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wallpapers";
            target = "Pictures/wallpapers";
          };
          wayland-cursor-fix = {
            enable = true;
            recursive = false;
            text = ''
              [Icon Theme]
              Inherits=Bibata-${catppuccin-accent-upper}-Mocha
            '';
            target = "${config.xdg.dataHome}/icons/default/index.theme";
          };
        };
        packages = with pkgs; [
          #catppuccinifier.packages.${pkgs.system}.cli
          bibata-sky-mocha
          gnome.adwaita-icon-theme
          hicolor-icon-theme
          vivid
        ];
        /*     pointerCursor = {
      name = "Bibata-${catppuccin-accent-upper}-Mocha";
      package = bibata-sky-mocha;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
        }; */
        sessionVariables = {
          GSETTINGS_BACKEND = "keyfile";
          #GTK_THEME = config.gtk.theme.name;
          GTK_USE_PORTAL = "1";
          LS_COLORS = "$(vivid generate catppuccin-mocha)";
          MICRO_TRUECOLOR = "1";
          NNN_COLORS = "#04020301;4231";
          NNN_FCOLORS = "030304020705050801060301";
          XCURSOR_SIZE = "24";
        };
      };
      programs = {
        alacritty = {
          catppuccin.enable = true;
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
            /*         import = [
          "${inputs.catppuccin-alacritty}/catppuccin-mocha.toml"
            ]; */
            window = {
              opacity = 0.7;
              blur = true;
            };
          };
        };
        bat = {
          catppuccin.enable = true;
          config = {
            pager = "less -FR";
            #theme = "Catppuccin-mocha";
          };
          /*       themes = {
        Catppuccin-mocha = {
          src = "${inputs.catppuccin-bat}/themes";
          file = "Catppuccin Mocha.tmTheme";
        };
          }; */
        };
        btop = {
          catppuccin.enable = true;
          settings = {
            #color_theme = "catppuccin_mocha";
            theme_background = false;
          };
        };
        foot = {
          settings = {
            colors = {
              "alpha" = "0.7";
              "foreground" = "cdd6f4"; # Text
              "background" = "1e1e2e"; # Base
              "regular0" = "45475a"; # Surface 1
              "regular1" = "f38ba8"; # red
              "regular2" = "a6e3a1"; # green
              "regular3" = "f9e2af"; # yellow
              "regular4" = "89b4fa"; # blue
              "regular5" = "f5c2e7"; # pink
              "regular6" = "94e2d5"; # teal
              "regular7" = "bac2de"; # Subtext 1
              "bright0" = "585b70"; # Surface 2
              "bright1" = "f38ba8"; # red
              "bright2" = "a6e3a1"; # green
              "bright3" = "f9e2af"; # yellow
              "bright4" = "89b4fa"; # blue
              "bright5" = "f5c2e7"; # pink
              "bright6" = "94e2d5"; # teal
              "bright7" = "a6adc8"; # Subtext 0
            };
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
          delta = {
            catppuccin.enable = true;
          };
        };
        helix = {
          catppuccin.enable = true;
          settings = {
            theme = lib.mkForce "catppuccin_transparent";
          };
          themes = {
            catppuccin_transparent =
              {
                "inherits" = "catppuccin-mocha";
                "ui.background" = "none";
              };
          };
        };
        konsole = {
          profiles = {
            "${username}" = {
              colorScheme = "Catppuccin-Mocha";
              font = {
                name = "${mono-font}";
                size = 14;
              };
            };
          };
        };
        lazygit = {
          catppuccin.enable = true;
          settings = {
            gui = {
              border = "single";
              mainPanelSplitMode = "vertical";
              nerdFontsVersion = "3";
              scrollHeight = 10;
              scrollOffMargin = 4;
              showFileTree = false;
              sidePanelWidth = 0.3333;
              /*           theme = {
            activeBorderColor = [ "#89dceb" "bold" ]; # ${catppuccin-accent-lower}
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            selectedRangeBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#f38ba8" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
              }; */
            };
          };
        };
        micro = {
          catppuccin.enable = true;
          /*       settings = {
        colorscheme = "catppuccin-mocha";
          }; */
        };
        nixvim = {
          colorschemes.catppuccin = {
            enable = true;
            settings = {
              background.dark = "mocha";
              flavour = "mocha";
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
            colorScheme = "CatppuccinMocha${catppuccin-accent-upper}";
            cursorTheme = "Bibata-${catppuccin-accent-upper}-Mocha";
            iconTheme = "Papirus-Dark";
            lookAndFeel = "Catppuccin-Mocha-${catppuccin-accent-upper}";
            theme = "default";
          };
          /*       configFile = {
        "kdeglobals"."General"."fixed" = "${mono-font},13,-1,5,50,0,0,0,0,0";
        "kdeglobals"."General"."font" = "${sans-font},13,-1,5,53,0,0,0,0,0";
        "kdeglobals"."General"."menuFont" = "${sans-font},13,-1,5,53,0,0,0,0,0";
        "kdeglobals"."General"."smallestReadableFont" = "${sans-font},11,-1,5,53,0,0,0,0,0";
        "kdeglobals"."General"."toolBarFont" = "${sans-font},13,-1,5,53,0,0,0,0,0";
        "kdeglobals"."General"."XftAntialias" = true;
        "kdeglobals"."General"."XftHintStyle" = "hintslight";
        "kdeglobals"."General"."XftSubPixel" = "rgb";
        "kdeglobals"."KDE"."widgetStyle" = "Breeze";
        "kdeglobals"."WM"."activeBackground" = "30,30,46";
        "kdeglobals"."WM"."activeBlend" = "205,214,244";
        "kdeglobals"."WM"."activeFont" = "${sans-font},13,-1,5,50,0,0,0,0,0";
        "kdeglobals"."WM"."activeForeground" = "205,214,244";
        "kdeglobals"."WM"."inactiveBackground" = "17,17,27";
        "kdeglobals"."WM"."inactiveBlend" = "166,173,200";
        "kdeglobals"."WM"."inactiveForeground" = "166,173,200";
        "plasmarc"."Wallpapers"."usersWallpapers" = "/home/${username}/Pictures/wallpapers/layered-waves-haikei.png,/home/${username}/Pictures/wallpapers/stacked-peaks-haikei.png";
          }; */
        };
        starship = {
          catppuccin.enable = true;
          /*       settings = {
        palette = "catppuccin_mocha";
          } // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-starship}/palettes/mocha.toml"); */
        };
        vscode = {
          extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
            catppuccin.catppuccin-vsc-icons
            catppuccin.catppuccin-vsc
          ];
          userSettings = {
            "catppuccin.accentColor" = "${catppuccin-accent-lower}";
            "catppuccin.customUIColors"."mocha"."statusBar.foreground" = "accent";
            "editor.fontFamily" = "'${mono-font}', 'monospace', monospace";
            "editor.fontLigatures" = true;
            "editor.fontSize" = 18;
            "glassit.alpha" = 210;
            "terminal.integrated.fontFamily" = "${mono-font}";
            "terminal.integrated.fontSize" = 14;
            "terminal.integrated.fontWeight" = "normal";
            "workbench.colorTheme" = "Catppuccin Mocha";
            "workbench.iconTheme" = "catppuccin-mocha";
          };
        };
        zellij = {
          settings = {
            theme = "catppuccin-mocha";
          };
        };
      };
      services = {
        xsettingsd = {
          settings = {
            "Gtk/CursorThemeSize" = 32;
            "Gtk/CursorThemeName" = "Bibata-${catppuccin-accent-upper}-Mocha";
            "Gtk/FontName" = "${sans-font},  13";
            "Net/IconThemeName" = "Papirus-Dark";
            "Net/ThemeName" = "Catppuccin-Mocha-Standard-${catppuccin-accent-upper}-Dark";
          };
        };
      };
      wayland.windowManager.hyprland = {
        catppuccin.enable = true;
      };
      /*       xdg.configFile = {
        #https://github.com/catppuccin/gtk/pull/151/files
        "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      }; */
      xresources = {
        properties = {
          "Xcursor.size" = 24;
          "Xcursor.theme" = "Bibata-${catppuccin-accent-upper}-Mocha";
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
