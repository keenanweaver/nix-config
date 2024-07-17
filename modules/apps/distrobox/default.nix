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
      systemPackages = with pkgs; [ distrobox_git ];
    };
    home-manager.users.${username} =
      {
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
          config-distrobox-assemble-desktop = {
            enable = true;
            text = (
              if vars.gaming then
                ''
                  [bazzite-arch-exodos]
                  image=ghcr.io/ublue-os/arch-distrobox:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true
                  volume="/etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"

                  [bazzite-arch-gaming]
                  image=ghcr.io/ublue-os/arch-distrobox:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true
                  volume="/etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"                
                ''
              else
                ''''
            );
            target = "${config.xdg.configHome}/distrobox/distrobox.ini";
          };
          config-distrobox-bootstrap = {
            enable = true;
            text =
              ''
                #!/usr/bin/env bash
                ## Set paru settings
                mkdir -p $XDG_CONFIG_HOME/paru
                xh -o "$XDG_CONFIG_HOME/paru/paru.conf" -d https://raw.githubusercontent.com/Morganamilo/paru/master/paru.conf
                sd '#SudoLoop' 'SudoLoop' "$XDG_CONFIG_HOME/paru/paru.conf"
                sd '#CleanAfter' 'CleanAfter' "$XDG_CONFIG_HOME/paru/paru.conf"
                sd '#BottomUp' 'BottomUp' "$XDG_CONFIG_HOME/paru/paru.conf"
                ## Add Chaotic AUR
                sudo pacman-key --init
                sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
                sudo pacman-key --lsign-key 3056513887B78AEB
                sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
                if ! rg "chaotic" /etc/pacman.conf; then
                  echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
                fi
                ## TODO: atuin
                ## Set up containers
              ''
              + lib.optionalString vars.gaming ''
                ## Base packages
                paru -Syu --needed --noconfirm   \
                gamemode                         \
                gamescope-git                    \
                kdialog                          \
                lib32-gamemode                   \
                lib32-libpulse                   \
                lib32-mangohud                   \
                lib32-obs-vkcapture-git          \
                lib32-vkbasalt                   \
                lib32-vulkan-mesa-layers         \
                lib32-vulkan-radeon              \
                lib32-openal                     \
                lib32-pipewire                   \
                lib32-pipewire-jack              \
                libva-mesa-driver                \
                mangohud                         \
                vkbasalt                         \
                vulkan-mesa-layers               \
                obs-vkcapture-git                \
                openal                           \
                pipewire                         \
                pipewire-pulse                   \
                pipewire-alsa                    \
                pipewire-jack                    \
                wireplumber                      \
                xdg-desktop-portal-kde
                ## Install necessary packages
                paru -S --needed --noconfirm     \
                archlinux-keyring                \
                base-devel                       \
                yay
                if [[ "$CONTAINER_ID" =~ ^bazzite-arch-exodos ]]; then
                  # Games/emulators/tools
                  paru -S --needed --noconfirm \
                  dbgl                         \
                  fluidsynth                   \
                  gwenview                     \
                  innoextract                  \
                  konsole                      \
                  okular
                elif [[ "$CONTAINER_ID" =~ ^bazzite-arch-gaming ]]; then
                  # Packages that will initially fail
                  paru -S --needed --noconfirm \
                  sm64ex-nightly-git           \
                  #soh                          \
                  #soh-otr-n64_pal_11
                  # Download & place required data files
                  #xh -o "$HOME/zeldaoot.zip" -d https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Legend%20of%20Zelda%2C%20The%20-%20Ocarina%20of%20Time%20%28USA%29%20%28Rev%202%29.zip
                  #ouch d "$HOME/zeldaoot.zip" -y -d "$XDG_CACHE_HOME/paru/clone/soh-otr-n64_pal_11"
                  #fd 'Zelda' -e z64 $XDG_CACHE_HOME/paru/clone/soh-otr-n64_pal_11 -x mv {} "$XDG_CACHE_HOME/paru/clone/soh-otr-n64_pal_11/baserom.z64"
                  xh -o "$HOME/mario64.zip" -d https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Super%20Mario%2064%20%28USA%29.zip
                  ouch d "$HOME/mario64.zip" -y -d "$XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git"
                  fd 'Mario' -e z64 $XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git -x mv {} "$XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git/baserom.us.z64"
                  # Try again
                  paru -S --needed --noconfirm \
                  sm64ex-nightly-git           \
                  #soh                          \
                  #soh-otr-n64_pal_11
                  # Games/emulators/tools
                  paru -S --needed --noconfirm \
                  2s2h-bin                     \
                  aaru                         \
                  archipelagomw-bin            \
                  bizhawk-bin                  \
                  jazzjackrabbit               \
                  jazzjackrabbit2              \
                  lab3d-sdl                    \
                  mesen2-git                   \
                  nuked-sc55                   \
                  openxcom-extended            \
                  perfectdark                  \
                  portproton                   \
                  sonicthehedgehog             \
                  sonicthehedgehog2            \
                  supermarioworld              \
                  xash3d-fwgs-git              \
                  zelda64recomp-bin            \
                  zeldalttp                    \
                  zeldaoot 
                else 
                  echo "Container hostname not found"
                fi
              '';
            target = "${config.xdg.configHome}/distrobox/bootstrap.sh";
            executable = true;
          };
          config-distrobox-config-file = {
            enable = true;
            text = ''
              xhost +si:localuser:$USER >/dev/null
            '';
            target = "${config.xdg.configHome}/distrobox/distrobox.conf";
          };
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
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /home/${username}/Games/daikatana/${bin}  "$@"
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
              args = "gamemoderun obs-gamecapture mangohud --dlsym";
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
              args = "gamemoderun obs-gamecapture";
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
              exec = "env GTK_THEME=Breeze-Dark faugus-launcher";
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
              exec = "env GTK_THEME=Breeze-Dark portproton";
              icon = "${config.xdg.dataHome}/PortProton/data/img/w.png";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
            };
          };
        };
      };
  };
}
