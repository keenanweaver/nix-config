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
        inputs,
        username,
        pkgs,
        vars,
        ...
      }:
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
          config-distrobox-config-file = {
            enable = true;
            text = ''
              xhost +si:localuser:$USER >/dev/null
            '';
            target = "${config.xdg.configHome}/distrobox/distrobox.conf";
          };
        };
        home.packages =
          with pkgs;
          [ xorg.xhost ]
          ++ lib.optionals vars.gaming [
            (writeShellScriptBin "bootstrap-distrobox" ''
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
              ${lib.optionalString vars.gaming ''
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
                  sm64ex-nightly-git
                  # Download & place required data files
                  xh -o "$HOME/mario64.zip" -d https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Super%20Mario%2064%20%28USA%29.zip
                  ouch d "$HOME/mario64.zip" -y -d "$XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git"
                  fd 'Mario' -e z64 $XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git -x mv {} "$XDG_CACHE_HOME/paru/clone/sm64ex-nightly-git/baserom.us.z64"
                  # Try again
                  paru -S --needed --noconfirm \
                  sm64ex-nightly-git
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
                  # Nuked-SC55
                  sudo cp ${inputs.nonfree}/Music/roland/{rom1.bin,rom2.bin,rom_sm.bin,waverom1.bin,waverom2.bin} /usr/share/nuked-sc55
                  sudo chmod 644 /usr/share/nuked-sc55/*.bin
                else 
                  echo "Container hostname not found"
                fi
              ''}'')
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "2s2h";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec '${bin-export}' "$@"
                else
                	exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "";
                bin = "aaru";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec ${bin-export} "$@"
                else
                	exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "/opt/Archipelago/ArchipelagoLauncher";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "archipelago-db" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec '${bin-export}' "$@"
                else
                	exec '${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "bizhawk";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "/home/${username}/Games/daikatana/daikatana";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "daikatana-db" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "obs-gamecapture mangohud";
                bin = "dbgl";
                bin-export = "${bin}-db";
                container = "bazzite-arch-exodos";
              in
              writeShellScriptBin "${bin-export}" ''
                export GTK_USE_PORTAL=0
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "obs-gamecapture mangohud";
                bin = "dosbox";
                bin-export = "${bin}-db";
                container = "bazzite-arch-exodos";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "exogui";
                bin-export = "${bin}-db";
                container = "bazzite-arch-exodos";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/mnt/crusader/eXo/eXoDOS/exogui/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/mnt/crusader/eXo/eXoDOS/exogui/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "obs-gamecapture";
                bin = "faugus-launcher";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                export GTK_USE_PORTAL=0
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "jazzjackrabbit";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "jazzjackrabbit2";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "lab3d-sdl";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture";
                bin = "mesen2";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "";
                bin = "nuked-sc55";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "openxcom";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud --dlsym";
                bin = "perfectdark";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "portproton";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                export GTK_USE_PORTAL=0
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "sonic";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "sonic2";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "sm64ex-nightly";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "supermarioworld";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture";
                bin = "zelda64recomp";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "zeldalttp";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
            (
              let
                args = "gamemoderun obs-gamecapture mangohud";
                bin = "zeldaoot";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '/usr/bin/${bin}' "$@"
                fi
              ''
            )
          ];
        xdg = {
          desktopEntries = {
            archipelago = lib.mkIf cfg.gaming {
              name = "Archipelago";
              comment = "Multiworld multi-game randomizer";
              exec = "archipelago-db";
              icon = "archipelago";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            bizhawk = lib.mkIf cfg.gaming {
              name = "bizhawk";
              comment = "A multi-platform emulator with full re-recording support and Lua scripting";
              exec = "bizhawk-db";
              icon = "bizhawk";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            dosbox = lib.mkIf cfg.gaming {
              name = "dosbox-staging";
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
              name = "exogui";
              comment = "eXoDOS Launcher";
              exec = "exogui-db";
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
              exec = "faugus-launcher-db";
              icon = "faugus-launcher";
              categories = [ "Game" ];
            };
            mesen2 = lib.mkIf cfg.gaming {
              name = "Mesen2";
              comment = "Multi-system emulator";
              exec = "mesen2-db";
              icon = "mesen";
              categories = [
                "Game"
                "Emulator"
              ];
            };
            nuked-sc55 = lib.mkIf cfg.gaming {
              name = "Nuked SC-55";
              comment = "Roland SC-55 emulator";
              exec = "nuked-sc55-db";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
            };
            portproton = lib.mkIf cfg.gaming {
              name = "PortProton";
              comment = "Proton launcher";
              exec = "portproton-db";
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
