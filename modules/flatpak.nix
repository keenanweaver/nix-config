{
  flake.modules = {
    homeManager.desktop-profile =
      {
        config,
        inputs,
        osConfig,
        ...
      }:
      {
        imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
        home = {
          sessionPath = [
            "/var/lib/flatpak/exports/bin"
            "${config.xdg.dataHome}/flatpak/exports/bin"
          ];
        };
        services.flatpak = {
          overrides = {
            global = {
              Context = {
                filesystems = [
                  "/nix/store:ro"
                  "/run/current-system/sw/bin:ro"
                  "/run/media/${osConfig.my.user}:ro"
                  # Theming
                  "${config.home.homeDirectory}/.icons:ro"
                  "${config.home.homeDirectory}/.themes:ro"
                  "xdg-config/fontconfig:ro"
                  "xdg-config/gtkrc:ro"
                  "xdg-config/gtkrc-2.0:ro"
                  "xdg-config/gtk-2.0:ro"
                  "xdg-config/gtk-3.0:ro"
                  "xdg-config/gtk-4.0:ro"
                  "xdg-data/fonts:ro"
                  "xdg-data/themes:ro"
                  "xdg-data/icons:ro"
                ];
              };
              Environment = {
                # Wrong cursor in flatpaks fix
                XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
              };
            };
            "io.github.ungoogled_software.ungoogled_chromium" = {
              Environment = {
                PIPEWIRE_NODE = "Browser";
                PULSE_SINK = "Browser";
              };
            };
            "net.mullvad.MullvadBrowser" = {
              Environment = {
                PIPEWIRE_NODE = "Browser";
                PULSE_SINK = "Browser";
              };
            };
          };
          packages = [
            "io.github.ungoogled_software.ungoogled_chromium"
            "net.mullvad.MullvadBrowser"
          ];
          remotes = [
            {
              location = "https://flathub.org/repo/flathub.flatpakrepo";
              name = "flathub";
            }
            {
              location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
              name = "flathub-beta";
            }
          ];
          uninstallUnmanaged = false;
        };
      };
    nixos.desktop-profile =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
        environment.systemPackages = with pkgs; [
          flatpak-builder
          xdg-dbus-proxy
        ];
        preservation.preserveAt."/persist".directories = [
          "/var/lib/flatpak"
        ];
        services.flatpak.enable = true;
        users.users.${config.my.user}.extraGroups = [ "flatpak" ];
        xdg.portal.enable = true;
      };
  };
  flake-file.inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
}
