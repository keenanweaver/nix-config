{
  lib,
  config,
  username,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.flatpak;
in
{

  options = {
    flatpak = {
      enable = lib.mkEnableOption "Enable flatpak in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      flatpak = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ flatpak-builder ];

    systemd.services = {
      "home-manager-${username}" = {
        serviceConfig.TimeoutStartSec = pkgs.lib.mkForce 1200;
      };
    };

    users.users.${username}.extraGroups = [ "flatpak" ];

    xdg.portal.enable = true;

    home-manager.users.${username} =
      { config, ... }:
      {
        services.flatpak = {
          packages = [
            "chat.revolt.RevoltDesktop"
            "com.github.tchx84.Flatseal"
            "com.obsproject.Studio"
            "fr.romainvigier.MetadataCleaner"
            "io.github.dvlv.boxbuddyrs"
            "io.github.ungoogled_software.ungoogled_chromium"
            "io.github.zen_browser.zen"
            "it.mijorus.gearlever"
            "net.mullvad.MullvadBrowser"
            "no.mifi.losslesscut"
            "org.atheme.audacious"
            "org.filezillaproject.Filezilla"
            "org.fooyin.fooyin"
            "org.kde.kdenlive"
            "org.musicbrainz.Picard"
            "org.onlyoffice.desktopeditors"
            "org.rncbc.qpwgraph"
            "org.signal.Signal"
            "org.squidowl.halloy"
            "xyz.armcord.ArmCord"
          ];
          remotes = [
            {
              name = "flathub";
              location = "https://flathub.org/repo/flathub.flatpakrepo";
            }
            {
              name = "flathub-beta";
              location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
            }
          ];
          overrides = {
            global = {
              Context = {
                filesystems =
                  [
                    "/nix/store:ro"
                    "/run/current-system/sw:ro"
                    "/run/media/${username}:ro"
                    # Theming
                    "${config.home.homeDirectory}/.icons:ro"
                    "${config.home.homeDirectory}/.themes:ro"
                    "xdg-config/fontconfig:ro"
                    "xdg-config/gtkrc:ro"
                    "xdg-config/gtkrc-2.0:ro"
                    "xdg-config/gtk-2.0:ro"
                    "xdg-config/gtk-3.0:ro"
                    "xdg-config/gtk-4.0:ro"
                    "xdg-data/themes:ro"
                    "xdg-data/icons:ro"
                  ]
                  ++ lib.optionals vars.gaming [
                    "xdg-config/MangoHud:ro"
                    "xdg-run/.flatpak/com.xyz.armcord.ArmCord:create"
                    "xdg-run/discord-ipc-*"
                  ];
                /*
                  sockets = [
                                 # Force Wayland by default
                                 "wayland"
                                 "!x11"
                                 "!fallback-x11"
                               ];
                */
              };
              Environment = {
                # Wrong cursor in flatpaks fix
                XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
              };
            };
            "io.github.zen_browser.zen" = {
              Environment = {
                MOZ_ENABLE_WAYLAND = "1";
              };
            };
            "it.mijorus.gearlever" = {
              Context = {
                filesystems = [ "${config.home.homeDirectory}/.local/bin" ];
              };
            };
            "one.ablaze.floorp" = {
              Environment = {
                MOZ_ENABLE_WAYLAND = "1";
              };
            };
            "org.atheme.audacious" = {
              Context = {
                sockets = [
                  "!wayland" # For Winamp skins
                ];
              };
            };
            "org.fooyin.fooyin" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Media/Audio/Music"
                  "${config.home.homeDirectory}/Music"
                ];
              };
            };
            "org.musicbrainz.Picard" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Media/Audio/Music"
                  "!home"
                  "xdg-download"
                  "${config.home.homeDirectory}/Music"
                ];
              };
            };
            "org.signal.Signal" = {
              Context = {
                filesystems = [
                  "!xdg-public-share"
                  "!xdg-videos"
                  "!xdg-pictures"
                  "!xdg-download"
                  "!xdg-music"
                  "!xdg-desktop"
                  "!xdg-documents"
                ];
                /*
                  sockets = [
                                 "wayland"
                                 "x11"
                               ];
                */
              };
            };
          };
        };
      };
  };
}
