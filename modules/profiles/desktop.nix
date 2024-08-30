{
  lib,
  config,
  pkgs,
  username,
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
    hyprland.enable = false;
    kde.enable = true;
    looking-glass.enable = true;
    mumble.enable = true;
    office.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;
    #zed.enable = true;

    environment = {
      systemPackages = with pkgs; [ xdg-desktop-portal ];
    };
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
          apostrophe
          (writeShellApplication {
            name = "bootstrap-baremetal";
            runtimeInputs = with pkgs; [
              curl
              distrobox_git
              fd
              findutils
              flatpak
              jq
              xh
            ];
            text = ''
              distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
              ${lib.optionalString vars.gaming ''script-game-stuff''}
            '';
          })
          cyanrip
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
          mimeApps = {
            enable = true;
            associations = {
              added = {
                "application/json" = [ "org.kde.kate.desktop" ];
                "application/pdf" = [
                  "org.kde.okular.desktop"
                  "io.github.zen_browser.zen.desktop"
                ];
                "application/toml" = [ "org.kde.kate.desktop" ];
                "application/x-bat" = [ "org.kde.kate.desktop" ];
                "application/x-cue" = [ "cdemu-client.desktop" ];
                "application/x-msdownload" = [ "wine.desktop" ];
                "application/xhtml+xml" = [ "io.github.zen_browser.zen.desktop" ];
                "application/xml" = [ "org.kde.kate.desktop" ];
                "application/x-shellscript" = [ "org.kde.kate.desktop" ];
                "audio/*" = [ "org.fooyin.fooyin.desktop" ];
                "image/*" = [ "org.kde.gwenview.desktop" ];
                "inode/directory" = [ "org.kde.dolphin.desktop" ];
                "text/*" = [
                  "org.kde.kate.desktop"
                  "Helix.desktop"
                  "micro.desktop"
                  "nvim.desktop"
                ];
                "text/html" = [
                  "io.github.zen_browser.zen.desktop"
                  "net.mullvad.MullvadBrowser.desktop"
                  "org.kde.kate.desktop"
                ];
                "video/*" = [ "org.kde.haruna.desktop" ];
                "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
                "x-scheme-handler/http" = [ "io.github.zen_browser.zen.desktop" ];
                "x-scheme-handler/https" = [ "io.github.zen_browser.zen.desktop" ];
              };
              removed = { };
            };
            defaultApplications = {
              "application/x-cue" = [ "cdemu-client.desktop" ];
              "application/x-msdownload" = [ "wine.desktop" ];
              "audio/aac" = [ "org.fooyin.fooyin.desktop" ];
              "audio/flac" = [ "org.fooyin.fooyin.desktop" ];
              "audio/mpeg" = [ "org.fooyin.fooyin.desktop" ];
              "audio/ogg" = [ "org.fooyin.fooyin.desktop" ];
              "audio/webm" = [ "org.kde.haruna.desktop" ];
              "image/bmp" = [ "org.kde.gwenview.desktop" ];
              "image/gif" = [ "org.kde.gwenview.desktop" ];
              "image/jpeg" = [ "org.kde.gwenview.desktop" ];
              "image/png" = [ "org.kde.gwenview.desktop" ];
              "image/webp" = [ "org.kde.gwenview.desktop" ];
              "text/html" = [ "io.github.zen_browser.zen.desktop" ];
              "text/plain" = [ "org.kde.kate.desktop" ];
              "video/mp4" = [ "org.kde.haruna.desktop" ];
              "video/mpeg" = [ "org.kde.haruna.desktop" ];
              "video/quicktime" = [ "org.kde.haruna.desktop" ];
              "video/webm" = [ "org.kde.haruna.desktop" ];
              "video/x-flv" = [ "org.kde.haruna.desktop" ];
              "video/x-matroska" = [ "org.kde.haruna.desktop" ];
              "video/x-ms-wmv" = [ "org.kde.haruna.desktop" ];
              "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
              "x-scheme-handler/http" = [ "io.github.zen_browser.zen.desktop" ];
              "x-scheme-handler/https" = [ "io.github.zen_browser.zen.desktop" ];
              "x-scheme-handler/ror2mm" = [ "r2modman.desktop" ];
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
