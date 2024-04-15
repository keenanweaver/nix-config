{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.kde;
in
{
  imports = [
    ./plasma-manager
  ];

  options = {
    kde = {
      enable = mkEnableOption "Enable kde in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [ elisa kwrited ];
      systemPackages = with pkgs; with pkgs.kdePackages; [
        ffmpegthumbnailer
        colord-kde
        discover
        filelight
        ghostwriter
        kate
        kcalc
        kcron
        kdesu
        kdialog
        kio-extras
        kirigami-addons
        packagekit-qt # Discover store
        plasma-browser-integration
        qtimageformats
        qtstyleplugin-kvantum
        sddm-kcm
        syntax-highlighting
      ];
    };
    programs = {
      fuse = { userAllowOther = true; };
      kdeconnect = with pkgs; {
        enable = true;
      };
      partition-manager.enable = true;
    };
    services = {
      colord.enable = true;
      desktopManager = { plasma6.enable = true; };
      displayManager = {
        autoLogin = { user = "${username}"; };
        defaultSession = "plasmax11";
        sddm = {
          enable = true;
          settings = {
            General = {
              InputMethod = ""; # Remove virtual keyboard
            };
            wayland.enable = true;
          };
        };
      };
      xserver = {
        displayManager.setupCommands = ''
          ${pkgs.xorg.xhost}/bin/xhost +local:
        ''; # Distrobox games
        enable = true;
        excludePackages = with pkgs; [ xterm ];
        libinput = {
          mouse.accelProfile = "flat";
          touchpad.accelProfile = "flat";
        };
        xkb = {
          layout = "us";
        };
      };
    };
    xdg = {
      portal = {
        config.common.default = "*";
        extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gtk ];
        xdgOpenUsePortal = true;
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home = {
        file = {
          kate-lsp = {
            enable = true;
            recursive = false;
            text = ''
              {
                "servers": {
                  "css": {
                    "command": ["vscode-css-language-server", "--stdio"],
                    "url": "https://github.com/Microsoft/vscode/tree/main/extensions/css-language-features/server",
                    "highlightingModeRegex": "^CSS$"
                  },
                  "html": {
                    "command": ["vscode-html-language-server", "--stdio"],
                    "url": "https://github.com/Microsoft/vscode/tree/main/extensions/html-language-features/server",
                    "highlightingModeRegex": "^HTML$"
                  },
                  "json": {
                    "command": ["vscode-json-language-server", "--stdio"],
                    "url": "https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server",
                    "highlightingModeRegex": "^JSON$"
                  },
                  "markdown": {
                    "command": ["marksman"],
                    "url": "https://github.com/artempyanykh/marksman",
                    "highlightingModeRegex": "^Markdown$"
                  },
                  "nix": {
                    "command": ["nixd"],
                    "url": "https://github.com/nix-community/nixd",
                    "highlightingModeRegex": "^Nix$"
                  },
                  "python": {
                    "command": ["ruff-lsp"],
                    "url": "https://github.com/astral-sh/ruff-lsp",
                    "highlightingModeRegex": "^Python$"
                  },
                  "terraform": {
                    "rootIndicationFileNames": ["*.tf", "*.tfvars"]
                  }
                }
              }
            '';
            target = "${config.xdg.configHome}/kate/lspclient/settings.json";
          };
          konsole-profile = {
            enable = true;
            recursive = false;
            text = ''
              [Appearance]
              ColorScheme=Catppuccin-Mocha
              Font=JetBrainsMono Nerd Font,14,-1,5,50,0,0,0,0,0

              [General]
              Command=/etc/profiles/per-user/${username}/bin/zsh
              Name=${username}
              Parent=FALLBACK/
            '';
            target = "${config.xdg.dataHome}/konsole/${username}.profile";
          };
        };
      };
      services = {
        kdeconnect.enable = true;
      };
    };
  };
}
