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
        default = true;
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
        dotfiles,
        ...
      }:
      let
        dbe = "${config.xdg.dataHome}/distrobox/exports/bin";
      in
      {
        home.file = {
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
          db-nccm =
            let
              args = "";
              bin = "nccm";
              container = "bazzite-arch-sys";
            in
            {
              enable = true;
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
          db-qobuz-dl =
            let
              args = "";
              bin = "qobuz-dl";
              container = "bazzite-arch-sys";
            in
            {
              enable = true;
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
          db-supermario64 =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "supermario64";
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
          db-zeldamm =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "zeldamm";
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

            text =
              (
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
              )
              + ''

                [bazzite-arch-sys]
                home=${config.xdg.configHome}/distrobox/bazzite-arch-sys
                image=ghcr.io/ublue-os/bazzite-arch:latest
                init=true
                pull=false
                replace=false
                start_now=true
              '';
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
          distrobox-bootstrap-ansible-playbook = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/playbook.yml";
            target = "${config.xdg.configHome}/distrobox/playbook.yml";
          };
          distrobox-bootstrap-ansible-reqs = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/requirements.yml";
            target = "${config.xdg.configHome}/distrobox/requirements.yml";
          };
          distrobox-mangohud-gaming = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/MangoHud/MangoHud.conf";
          };
          distrobox-mangohud-exodos = {
            enable = vars.gaming;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/MangoHud/MangoHud.conf";
          };
          nccm = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nccm/nccm.yml";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/nccm/nccm.yml";
          };
        };
        home.packages = with pkgs; [ xorg.xhost ];
      };
  };
}
