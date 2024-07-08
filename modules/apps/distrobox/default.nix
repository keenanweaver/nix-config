{
  lib,
  config,
  username,
  pkgs,
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
    environment = {
      systemPackages = with pkgs; [
        distrobox_git
        lilipod
      ];
    };
    home-manager.users.${username} =
      {
        inputs,
        config,
        username,
        pkgs,
        vars,
        ...
      }:
      let
        dbe = "${config.xdg.dataHome}/distrobox/exports/bin";
      in
      {
        home.file = {
          db-2s2h =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "2s2h";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-aaru =
            let
              args = "";
              bin = "aaru";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-archipelago =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "/opt/Archipelago/ArchipelagoLauncher";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} ${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/archipelago  "$@"
                else
                	exec /opt/Archipelago/ArchipelagoLauncher "$@"
                fi
              '';
              target = "${dbe}/archipelago";
              executable = true;
            };
          db-bizhawk =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "bizhawk";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-daikatana =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "daikatana";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-dbgl =
            let
              args = "obs-gamecapture mangohud";
              bin = "dbgl";
              container = "bazzite-arch-exodos";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin} "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-dosbox =
            let
              args = "obs-gamecapture mangohud";
              bin = "dosbox";
              container = "bazzite-arch-exodos";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin} "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-exogui =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "exogui";
              container = "bazzite-arch-exodos";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /mnt/crusader/eXo/eXoDOS/exogui/${bin} "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-faugus =
            let
              args = "obs-gamecapture";
              bin = "faugus-launcher";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-jazzjackrabbit =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "jazzjackrabbit";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-jazzjackrabbit2 =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "jazzjackrabbit2";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-lab3d-sdl =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "lab3d-sdl";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-mesen =
            let
              args = "gamemoderun obs-gamecapture";
              bin = "mesen2";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-nuked-sc55 =
            let
              args = "";
              bin = "nuked-sc55";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-openxcom =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "openxcom";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-perfectdark =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "perfectdark";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-portproton =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "portproton";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-raze =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "raze";
              container = "bazzite-arch-gaming";
            in
            {
              enable = false;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-sonic =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "sonic";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-sonic2 =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "sonic2";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-sm64ex-nightly =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "sm64ex-nightly";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-supermarioworld =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "supermarioworld";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-zelda64recomp =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "zelda64recomp";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-zeldalttp =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "zeldalttp";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          db-zeldaoot =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "zeldaoot";
              container = "bazzite-arch-gaming";
            in
            {
              enable = vars.gaming;
              text = ''
                #!/usr/bin/env bash
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/${bin}";
              executable = true;
            };
          distrobox-assemble-desktop = {
            enable = true;
            text = (
              if vars.gaming then
                ''
                  [bazzite-arch-exodos]
                  home=${config.xdg.configHome}/distrobox/bazzite-arch-exodos
                  image=ghcr.io/ublue-os/bazzite-arch:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true

                  [bazzite-arch-gaming]
                  home=${config.xdg.configHome}/distrobox/bazzite-arch-gaming
                  image=ghcr.io/ublue-os/bazzite-arch:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true
                ''
              else
                ''''
            );
            target = "${config.xdg.configHome}/distrobox/distrobox.ini";
          };
          distrobox-bazzite-arch-exodos-catppuccin-konsole = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/Catppuccin-Mocha.colorscheme";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/konsole/Catppuccin-Mocha.colorscheme";
          };
          distrobox-bazzite-arch-exodos-gtk2 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-2.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-2.0";
          };
          distrobox-bazzite-arch-exodos-gtk3 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-3.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-3.0";
          };
          distrobox-bazzite-arch-exodos-gtk4 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-4.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-4.0";
          };
          distrobox-bazzite-arch-exodos-kdeglobals = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/kdeglobals";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/kdeglobals";
          };
          distrobox-bazzite-arch-exodos-konsole = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/konsole/${username}.profile";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/konsole/${username}.profile";
          };
          distrobox-bazzite-arch-exodos-themes = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/themes";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/themes";
          };
          distrobox-bazzite-arch-exodos-trolltech = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/Trolltech.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/Trolltech.conf";
          };
          distrobox-bazzite-arch-gaming-gtk2 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-2.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-2.0";
          };
          distrobox-bazzite-arch-gaming-gtk3 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-3.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-3.0";
          };
          distrobox-bazzite-arch-gaming-gtk4 = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-4.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-4.0";
          };
          distrobox-bazzite-arch-gaming-kdeglobals = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/kdeglobals";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/kdeglobals";
          };
          distrobox-bazzite-arch-gaming-konsole = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/konsole/${username}.profile";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.local/share/konsole/${username}.profile";
          };
          distrobox-bazzite-arch-gaming-themes = {
            enable = vars.gaming;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/themes";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.local/share/themes";
          };
          distrobox-bazzite-arch-gaming-trolltech = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/Trolltech.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/Trolltech.conf";
          };
          distrobox-bootstrap-ansible = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              paru -S --noconfirm --needed ansible
              ansible-galaxy collection install -r requirements.yml
              ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 ${config.xdg.configHome}/distrobox/playbook.yml
            '';
            target = "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh";
            executable = true;
          };
          distrobox-mangohud-gaming = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/MangoHud/MangoHud.conf";
          };
          distrobox-mangohud-exodos = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/MangoHud/MangoHud.conf";
          };
        };
        home.packages = with pkgs; [ xorg.xhost ];
        xdg = {
          desktopEntries = {
            archipelago = lib.mkIf cfg.gaming {
              name = "Archipelago";
              comment = "Multiworld multi-game randomizer";
              exec = "archipelago";
              icon = "archipelago";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            bizhawk = lib.mkIf cfg.gaming {
              name = "bizhawk";
              comment = "A multi-platform emulator with full re-recording support and Lua scripting";
              exec = "bizhawk";
              icon = "bizhawk";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            dosbox = lib.mkIf cfg.gaming {
              name = "dosbox-staging";
              comment = "DOSBox Staging";
              exec = "dosbox";
              icon = "dosbox-staging";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                Keywords = "dosbox;dos";
              };
            };
            exogui = lib.mkIf cfg.gaming {
              name = "exogui";
              comment = "eXoDOS Launcher";
              exec = "exogui";
              icon = "distributor-logo-ms-dos";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              settings = {
                Keywords = "exodos;dos";
              };
            };
            faugus = lib.mkIf cfg.gaming {
              name = "Faugus Launcher";
              comment = "Faugus Launcher";
              exec = "faugus-launcher";
              icon = "faugus-launcher";
              categories = [ "Game" ];
            };
            mesen2 = lib.mkIf cfg.gaming {
              name = "Mesen2";
              comment = "Multi-system emulator";
              exec = "mesen2";
              icon = "mesen";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            nuked-sc55 = lib.mkIf cfg.gaming {
              name = "Nuked SC-55";
              comment = "Roland SC-55 emulator";
              exec = "nuked-sc55";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
            };
            portproton = lib.mkIf cfg.gaming {
              name = "PortProton";
              comment = "Proton launcher";
              exec = "portproton";
              icon = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/PortProton/data/img/w.png";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
            };
          };
        };
      };
  };
}
