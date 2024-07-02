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
    };

    home-manager.users.${username} =
      {
        pkgs,
        config,
        vars,
        ...
      }:
      {
        home.file = {
          script-bootstrap-baremetal = {
            enable = true;
            text =
              ''
                #!/usr/bin/env bash
                fd 'rustdesk' /home/${username}/Downloads -e flatpak -x rm {}
                curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
                fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
                distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
              ''
              + lib.optionalString vars.gaming ''
                distrobox enter bazzite-arch-exodos -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
                distrobox enter bazzite-arch-gaming -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
                /home/${username}/.local/bin/game-stuff.sh
              '';
            target = ".local/bin/bootstrap-baremetal.sh";
            executable = true;
          };
        };
        home.packages = with pkgs; [
          apostrophe
          cyanrip
          neo
        ];
        xdg = {
          desktopEntries = {
            foobar2000 = {
              name = "foobar2000";
              comment = "Launch foobar2000 using Bottles.";
              exec = "bottles-cli run -p foobar2000 -b foobar2000";
              icon = "/home/${username}/Games/Bottles/foobar2000/icons/foobar2000.png";
              categories = [
                "AudioVideo"
                "Player"
                "Audio"
              ];
              noDisplay = false;
              startupNotify = true;
              actions = {
                "Configure" = {
                  name = "Configure in Bottles";
                  exec = "bottles -b foobar2000";
                };
              };
              settings = {
                StartupWMClass = "foobar2000";
              };
            };
            qobuz = {
              name = "Qobuz";
              comment = "Launch Qobuz using Bottles.";
              exec = "bottles-cli run -p Qobuz -b Qobuz";
              icon = "/home/${username}/Games/Bottles/Qobuz/icons/Qobuz.png";
              categories = [
                "AudioVideo"
                "Player"
                "Audio"
              ];
              noDisplay = false;
              startupNotify = true;
              actions = {
                "Configure" = {
                  name = "Configure in Bottles";
                  exec = "bottles -b Qobuz";
                };
              };
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
                  "one.ablaze.floorp.desktop"
                ];
                "application/toml" = [ "org.kde.kate.desktop" ];
                "application/x-bat" = [ "org.kde.kate.desktop" ];
                "application/x-cue" = [ "cdemu-client.desktop" ];
                "application/x-msdownload" = [ "wine.desktop" ];
                "application/xhtml+xml" = [ "one.ablaze.floorp.desktop" ];
                "application/xml" = [ "org.kde.kate.desktop" ];
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
                  "one.ablaze.floorp.desktop"
                  "net.mullvad.MullvadBrowser.desktop"
                  "org.kde.kate.desktop"
                ];
                "video/*" = [ "org.kde.haruna.desktop" ];
                "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
                "x-scheme-handler/http" = [ "one.ablaze.floorp.desktop" ];
                "x-scheme-handler/https" = [ "one.ablaze.floorp.desktop" ];
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
              "text/html" = [ "one.ablaze.floorp.desktop" ];
              "text/plain" = [ "org.kde.kate.desktop" ];
              "video/mp4" = [ "org.kde.haruna.desktop" ];
              "video/mpeg" = [ "org.kde.haruna.desktop" ];
              "video/quicktime" = [ "org.kde.haruna.desktop" ];
              "video/webm" = [ "org.kde.haruna.desktop" ];
              "video/x-flv" = [ "org.kde.haruna.desktop" ];
              "video/x-matroska" = [ "org.kde.haruna.desktop" ];
              "video/x-ms-wmv" = [ "org.kde.haruna.desktop" ];
              "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
              "x-scheme-handler/http" = [ "one.ablaze.floorp.desktop" ];
              "x-scheme-handler/https" = [ "one.ablaze.floorp.desktop" ];
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
