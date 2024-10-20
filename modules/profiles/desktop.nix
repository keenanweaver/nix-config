{
  lib,
  config,
  username,
  vars,
  ...
}:
let
  cfg = config.desktop;
in
{
  imports = [ ./base.nix ];

  options = {
    desktop = {
      enable = lib.mkEnableOption "Enable desktop in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # Custom modules
    base.enable = true;
    catppuccinTheming.enable = true;
    floorp.enable = true;
    hyprland.enable = false;
    kde.enable = true;
    mumble.enable = true;
    office.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;

    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Experimental = "true";
          }; # https://reddit.com/r/NixOS/comments/1aoteqb/keychron_k1_pro_bluetooth_nixos_wkde_install/kq49q9r/?context=3
        };
      };
      enableAllFirmware = true;
      i2c.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    services = {
      btrfs = {
        autoScrub = {
          enable = true;
          interval = "weekly";
        };
      };
      devmon.enable = true;
      fwupd.enable = true;
      udisks2 = {
        enable = true;
      };
    };

    home-manager.users.${username} =
      {
        pkgs,
        config,
        vars,
        ...
      }:
      {
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "bootstrap-baremetal";
            runtimeInputs = with pkgs; [
              distrobox_git
            ];
            text = ''
              distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
              ${lib.optionalString vars.gaming ''script-game-stuff''}
            '';
          })
          cyanrip
          mangareader
          mousai
          neo
        ];
        xdg = {
          desktopEntries = {
            foobar2000 = {
              name = "foobar2000";
              comment = "Launch foobar2000 using Bottles.";
              exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p foobar2000 -b foobar2000";
              icon = "${config.home.homeDirectory}/Games/Bottles/foobar2000/icons/foobar2000.png";
              categories = [
                "AudioVideo"
                "Player"
                "Audio"
              ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                StartupWMClass = "foobar2000";
              };
            };
            qobuz = {
              name = "Qobuz";
              comment = "Launch Qobuz using Bottles.";
              exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p Qobuz -b Qobuz";
              icon = "${config.home.homeDirectory}/Games/Bottles/Qobuz/icons/Qobuz.png";
              categories = [
                "AudioVideo"
                "Player"
                "Audio"
              ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                StartupWMClass = "Qobuz";
              };
            };
          };
          mimeApps =
            let
              audioPlayer = "org.fooyin.fooyin.desktop";
              browser = "io.github.zen_browser.zen.desktop"; # one.ablaze.floorp.desktop
              editor = "org.kde.kate.desktop";
              imageViewer = "org.kde.gwenview.desktop";
              pdfViewer = "org.kde.okular.desktop";
              videoPlayer = "org.kde.haruna.desktop";
            in
            {
              enable = true;
              defaultApplications =
                {
                  "audio/*" = audioPlayer;
                  "image/*" = imageViewer;
                  "video/*" = videoPlayer;
                  "text/*" = editor;
                  "text/html" = browser;
                  "text/plain" = editor;
                  "application/json" = editor;
                  "application/pdf" = pdfViewer;
                  "application/toml" = editor;
                  "application/x-bat" = editor;
                  "application/xhtml+xml" = browser;
                  "application/xml" = editor;
                  "application/x-shellscript" = editor;
                  "application/x-yaml" = editor;
                  "inode/directory" = "org.kde.dolphin.desktop";
                  "x-scheme-handler/bottles" = "com.usebottles.bottles.desktop";
                  "x-scheme-handler/http" = browser;
                  "x-scheme-handler/https" = browser;
                  "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
                }
                // lib.optionalAttrs vars.gaming {
                  "application/x-cue" = "cdemu-client.desktop";
                  "application/x-msdownload" = "wine.desktop";
                  "x-scheme-handler/ror2mm" = "r2modman.desktop";
                };
            };
          portal = {
            config.common.default = "*";
            enable = true;
            extraPortals = with pkgs; [
              kdePackages.xdg-desktop-portal-kde
              xdg-desktop-portal-gtk
            ];
          };
        };
      };
  };
}
