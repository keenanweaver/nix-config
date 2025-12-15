{
  lib,
  config,
  inputs,
  username,
  vars,
  ...
}:
let
  cfg = config.distrobox;
in
{
  options = {
    distrobox = {
      enable = lib.mkEnableOption "Enable distrobox in NixOS & home-manager";
      gaming = lib.mkOption {
        type = lib.types.bool;
        default = vars.gaming;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        config,
        pkgs,
        ...
      }:
      let
        db-package = config.programs.distrobox.package;
        mkDistroboxWrapper =
          {
            name,
            bin,
            container,
            args ? "${lib.getExe' pkgs.obs-studio-plugins.obs-vkcapture "obs-gamecapture"} ${config.programs.mangohud.package}/bin/mangohud",
            extraEnv ? {
              MANGOHUD_CONFIG = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
              PIPEWIRE_NODE = "Game";
              PULSE_SINK = "Game";
            },
            preExec ? "",
          }:
          pkgs.writeShellScriptBin "${name}-db" ''
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "export ${k}=\"${v}\"") extraEnv)}
            ${preExec}
            if [ -z "''${CONTAINER_ID}" ]; then
              exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '${bin}' "$@"
            elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
              exec "${db-package}/bin/distrobox-host-exec" '${name}-db' "$@"
            else
              exec '${bin}' "$@"
            fi
          '';
        gameWrappers = [
          {
            name = "archipelago";
            bin = "/opt/Archipelago/ArchipelagoLauncher";
            container = "bazzite-arch-gaming";
          }
          {
            name = "bizhawk";
            bin = "/usr/bin/bizhawk";
            container = "bazzite-arch-gaming";
          }
          {
            name = "daikatana";
            bin = "${config.home.homeDirectory}/Games/daikatana/daikatana";
            container = "bazzite-arch-gaming";
          }
          {
            name = "dbgl";
            bin = "/usr/bin/dbgl";
            container = "exodos";
            extraEnv = {
              GTK_USE_PORTAL = "0";
              GTK_THEME = "Breeze-Dark";
              PIPEWIRE_NODE = "Game";
              PULSE_SINK = "Game";
            };
          }
          {
            name = "dosbox";
            bin = "/usr/bin/dosbox";
            container = "exodos";
          }
          {
            name = "exogui";
            bin = "/mnt/crusader/Games/eXo/eXoDOS/exogui/exogui";
            args = "/usr/bin/obs-gamecapture ${config.programs.mangohud.package}/bin/mangohud";
            container = "exodos";
            preExec = "cd /mnt/crusader/Games/eXo/eXoDOS/exogui";
          }
          {
            name = "jazzjackrabbit";
            bin = "/usr/bin/jazzjackrabbit";
            container = "bazzite-arch-gaming";
          }
          {
            name = "lab3d-sdl";
            bin = "/usr/bin/lab3d-sdl";
            container = "bazzite-arch-gaming";
          }
          {
            name = "obs-gamecapture";
            bin = "/usr/bin/obs-gamecapture";
            container = "bazzite-arch-gaming";
          }
          {
            name = "portproton";
            bin = "/usr/bin/portproton";
            container = "bazzite-arch-gaming";
            extraEnv = {
              GTK_THEME = "Breeze-Dark";
              PIPEWIRE_NODE = "Game";
              PULSE_SINK = "Game";
            };
          }
          {
            name = "supermarioworld";
            bin = "/usr/bin/supermarioworld";
            container = "bazzite-arch-gaming";
          }
          {
            name = "xash3d";
            bin = "/usr/bin/xash3d";
            container = "bazzite-arch-gaming";
          }
          {
            name = "zeldalttp";
            bin = "/usr/bin/zeldalttp";
            container = "bazzite-arch-gaming";
          }
        ];
      in
      {
        programs =
          let
            custompath = ''
              if [ "''${CONTAINER_ID:-}" = "exodos" ]; then
                  PATH=${config.xdg.dataHome}/distrobox/exodos/dosbox:${config.xdg.dataHome}/distrobox/exodos/dbgl:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/rocm/bin:/var/lib/flatpak/exports/bin:${config.home.homeDirectory}/.local/share/flatpak/exports/bin:${config.home.homeDirectory}/.bin:${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/bin:/run/wrappers/bin:${config.home.homeDirectory}/.nix-profile/bin:/nix/profile/bin:${config.home.homeDirectory}/.local/state/nix/profile/bin:/etc/profiles/per-user/${username}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:${config.home.homeDirectory}/.config/zsh/plugins/cd-ls:${config.home.homeDirectory}/.config/zsh/plugins/zsh-fast-syntax-highlighting:${config.home.homeDirectory}/.config/zsh/plugins/nix-zsh-completions
              fi'';
          in
          {
            bash = {
              initExtra = lib.mkAfter ''
                ${custompath}
              '';
            };
            distrobox = {
              enable = true;
              containers = {
                exodos = lib.mkIf cfg.gaming {
                  #home = "${config.xdg.dataHome}/distrobox/exodos";
                  image = "ubuntu:24.04";
                  init = true;
                  replace = true;
                };
                bazzite-arch-gaming = lib.mkIf cfg.gaming {
                  #home = "${config.xdg.dataHome}/distrobox/bazzite-arch-gaming";
                  image = "ghcr.io/ublue-os/bazzite-arch:latest";
                  init = true;
                  replace = true;
                };
              };
              enableSystemdUnit = true;
              settings = {
                container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
              };
            };
            zsh = {
              initContent = lib.mkAfter ''
                ${custompath}
              '';
            };
          };
        home = {
          packages =
            with pkgs;
            [
              distrobox-tui
            ]
            ++ lib.optionals cfg.gaming (
              [
                (import ./bootstrap-distrobox.nix {
                  inherit
                    config
                    lib
                    username
                    pkgs
                    vars
                    ;
                })
              ]
              ++ map mkDistroboxWrapper gameWrappers
            );
        };

        xdg = {
          desktopEntries = {
            archipelago = lib.mkIf cfg.gaming {
              name = "Archipelago (distrobox)";
              comment = "Multiworld multi-game randomizer";
              exec = "archipelago-db";
              icon = "archipelago";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            bizhawk = lib.mkIf cfg.gaming {
              name = "bizhawk (distrobox)";
              comment = "A multi-platform emulator with full re-recording support and Lua scripting";
              exec = "bizhawk-db";
              icon = "bizhawk";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            dbgl = lib.mkIf cfg.gaming {
              name = "dbgl (distrobox)";
              comment = "DOSBox Game Launcher";
              exec = "dbgl-db";
              icon = "dosbox-staging";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                Keywords = "dosbox;dos";
              };
            };
            dosbox = lib.mkIf cfg.gaming {
              name = "dosbox-staging (distrobox)";
              comment = "DOSBox Staging";
              exec = "dosbox-db";
              icon = "dosbox-staging";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                Keywords = "dosbox;dos";
              };
            };
            exogui = lib.mkIf cfg.gaming {
              name = "exogui (distrobox)";
              comment = "eXoGUI";
              exec = "exogui-db";
              icon = "distributor-logo-ms-dos";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                Keywords = "dosbox;dos";
              };
            };
            portproton =
              let
                icon = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/Castro-Fidel/PortWINE/refs/heads/devel/data_from_portwine/img/w.png";
                  hash = "sha256-oC18xU2utU6Yoh3sZBsz/kkAeE2ZdQeet87eM3j7VWw=";
                };
              in
              lib.mkIf cfg.gaming {
                name = "PortProton (distrobox)";
                comment = "Proton launcher";
                exec = "portproton-db";
                icon = "${icon}";
                categories = [ "Game" ];
                noDisplay = false;
                startupNotify = true;
              };
          };
        };
      };
  };
}
