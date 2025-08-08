{
  lib,
  config,
  username,
  pkgs,
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
    # Apps
    easyeffects.enable = true;
    freetube.enable = true;
    mumble.enable = true;
    rmpc.enable = true;
    vesktop.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;
    zen-browser.enable = true;

    # System
    base.enable = true;
    catppuccinTheming.enable = true;
    kde.enable = true;
    office.enable = true;

    boot = {
      binfmt = {
        emulatedSystems = [
          "aarch64-linux"
        ];
      };
    };

    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            AutoEnable = false;
            ControllerMode = "bredr";
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
      geoclue2 = {
        enable = true;
        geoProviderUrl = "https://beacondb.net/v1/geolocate";
      };
      lact.enable = true;
      power-profiles-daemon.enable = true;
      udev.packages = with pkgs; [ android-udev-rules ];
    };

    home-manager.users.${username} =
      {
        pkgs,
        vars,
        ...
      }:
      {
        home.packages = with pkgs; [
          amdgpu_top
          audacious
          audacious-plugins
          caligula
          cyanrip
          filezilla
          fooyin
          freetube
          gearlever
          hacompanion
          halloy
          handbrake
          jellyfin-tui
          kdePackages.kdenlive
          losslesscut-bin
          mangareader
          metadata-cleaner
          mousai
          neo
          nvtopPackages.amd
          picard
          projectm-sdl-cpp
          puddletag
          qpwgraph
          qtscrcpy
          revolt-desktop
          rssguard
          rustdesk-flutter
          signal-desktop-bin
          varia
        ];
        xdg = {
          desktopEntries = {
            foobar2000 =
              let
                icon = pkgs.fetchurl {
                  url = "https://cdn2.steamgriddb.com/logo/ab2481c9f93d0ed3033a3281d865ccb2.png";
                  hash = "sha256-aPf8MLBDPh9Q6WdtY0tnfgKKHLJNtndYI6D3VHnrHls=";
                };
              in
              {
                name = "foobar2000";
                comment = "Launch foobar2000 using Bottles.";
                exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p foobar2000 -b foobar2000";
                icon = "${icon}";
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
            qobuz =
              let
                icon = pkgs.fetchurl {
                  url = "https://img.icons8.com/ios/50/FFFFFF/qobuz.png";
                  hash = "sha256-G7q/S8Svta+zd/ayv+GEE7luHQqnRDCxHe2uIuCecig=";
                };
              in
              {
                name = "Qobuz";
                comment = "Launch Qobuz using Bottles.";
                exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p Qobuz -b Qobuz";
                icon = "${icon}";
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
              browser = "app.zen_browser.zen.desktop";
              editor = "org.kde.kate.desktop";
              imageViewer = "org.kde.gwenview.desktop";
              pdfViewer = "org.kde.okular.desktop";
              videoPlayer = "org.kde.haruna.desktop";
            in
            {
              enable = true;
              defaultApplications = {
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
                "x-scheme-handler/sgnl" = "signal.desktop";
                "x-scheme-handler/signalcaptcha" = "signal.desktop";
                "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
              }
              // lib.optionalAttrs vars.gaming {
                "application/x-alcohol" = "cdemu-client.desktop";
                "application/x-cue" = "cdemu-client.desktop";
                "application/x-gd-rom-cue" = "cdemu-client.desktop";
                "application/x-msdownload" = "wine.desktop";
                "x-scheme-handler/ror2mm" = "r2modman.desktop";
              };
            };
        };
      };
  };
}
