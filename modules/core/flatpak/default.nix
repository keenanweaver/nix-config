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

    environment.systemPackages = with pkgs; [
      flatpak-builder
      xdg-dbus-proxy
    ];

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
        home = {
          sessionPath = [
            "/var/lib/flatpak/exports/bin"
            "${config.xdg.dataHome}/flatpak/exports/bin"
          ];
        };
        services.flatpak = {
          packages = [
            "io.github.DenysMb.Kontainer"
            "io.github.ungoogled_software.ungoogled_chromium"
            "net.mullvad.MullvadBrowser"
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
                filesystems = [
                  "/nix/store:ro"
                  "/run/current-system/sw/bin:ro"
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
                  "xdg-run/discord-ipc-*"
                ];
              };
              Environment = {
                # Wrong cursor in flatpaks fix
                XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
              };
            };
            "io.github.ungoogled_software.ungoogled_chromium" = {
              Environment = {
                PULSE_SINK = "Browser";
              };
            };
            "net.mullvad.MullvadBrowser" = {
              Environment = {
                PULSE_SINK = "Browser";
              };
            };
          };
          uninstallUnmanaged = false;
        };
      };
  };
}
