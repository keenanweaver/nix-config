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
        home = {
          sessionPath = [
            "/var/lib/flatpak/exports/bin"
            "${config.xdg.dataHome}/flatpak/exports/bin"
          ];
        };
        services.flatpak = {
          packages = [
            "com.github.tchx84.Flatseal"
            "com.obsproject.Studio"
            "io.github.ungoogled_software.ungoogled_chromium"
            "app.zen_browser.zen"
            "net.mullvad.MullvadBrowser"
          ];
          remotes = [
            {
              name = "flathub";
              location = "https://flathub.org/repo/flathub.flatpakrepo";
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
                    "xdg-run/discord-ipc-*"
                  ];
              };
              Environment = {
                # Wrong cursor in flatpaks fix
                XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
              };
            };
            "app.zen_browser.zen" = {
              Environment = {
                MOZ_ENABLE_WAYLAND = "1";
              };
            };
          };
        };
      };
  };
}
