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
  distrobox-autostart = (
    pkgs.writeShellApplication {
      name = "distrobox-autostart";
      runtimeInputs = with pkgs; [
        coreutils
        distrobox_git
      ];
      text = ''
        boxes=$(distrobox list | cut -d "|" -f 2 | tail +2 | xargs)
        for box in "''${boxes[@]}"; do
          distrobox-enter -n "$box" -T -- bash -l -c "exit"
        done
      '';
    }
  );
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
        boxbuddy
        distrobox_git
      ];
    };
    home-manager.users.${username} =
      {
        config,
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
                  image=ghcr.io/ublue-os/bazzite-arch:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true
                  unshare_netns=true
                  volume="/etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"

                  [bazzite-arch-gaming]
                  image=ghcr.io/ublue-os/bazzite-arch:latest
                  init=true
                  pull=false
                  replace=false
                  start_now=true
                  unshare_netns=true
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
          let
            db-package = pkgs.distrobox_git;
          in
          with pkgs;
          [
            distrobox-autostart
            xorg.xhost
          ]
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
                paru -Syu --needed --noconfirm \
                gamemode                       \
                gamescope-git                  \
                kdialog                        \
                lib32-gamemode                 \
                lib32-libpulse                 \
                lib32-mangohud                 \
                lib32-obs-vkcapture            \
                lib32-vkbasalt                 \
                lib32-vulkan-radeon            \
                lib32-openal                   \
                lib32-pipewire                 \
                lib32-pipewire-jack            \
                libva-mesa-driver              \
                mangohud                       \
                vkbasalt                       \
                obs-vkcapture                  \
                openal                         \
                parui                          \
                pipewire                       \
                pipewire-pulse                 \
                pipewire-alsa                  \
                pipewire-jack                  \
                wireplumber                    \
                xdg-desktop-portal-kde
                ## Install necessary packages
                paru -S --needed --noconfirm   \
                archlinux-keyring              \
                base-devel                     \
                yay
                if [[ "$CONTAINER_ID" =~ ^bazzite-arch-exodos ]]; then
                  # Games/emulators/tools
                  paru -S --needed --noconfirm \
                  dbgl
                elif [[ "$CONTAINER_ID" =~ ^bazzite-arch-gaming ]]; then
                  # Packages that will initially fail
                  paru -S --needed --noconfirm \
                  # Games/emulators/tools
                  paru -S --needed --noconfirm \
                  2s2h-bin                     \
                  archipelagomw-bin            \
                  bizhawk-bin                  \
                  faugus-launcher-git          \
                  jazzjackrabbit               \
                  lab3d-sdl                    \
                  openxcom-extended            \
                  portproton                   \
                  sonicthehedgehog             \
                  sonicthehedgehog2            \
                  supermarioworld              \
                  xash3d-fwgs-git              \
                  zelda64recomp-bin            \
                  zeldalttp                    \
                  zeldaoot
                  # Other steps
                  sudo chown -R ${username} /opt/bizhawk
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "/opt/Archipelago/ArchipelagoLauncher";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "archipelago-db" ''
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "${config.home.homeDirectory}/Games/daikatana/daikatana";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "daikatana-db" ''
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  exec distrobox-host-exec '${bin-export}' "$@"
                else
                  exec '${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/sbin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "exogui";
                bin-export = "${bin}-db";
                container = "bazzite-arch-exodos";
              in
              writeShellScriptBin "${bin-export}" ''
                export PULSE_SINK="Game"
                cd /mnt/crusader/eXo/eXoDOS/exogui
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/mnt/crusader/eXo/eXoDOS/exogui/${bin}' "$@"
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
                export GTK_THEME=Breeze-Dark
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "obs-gamecapture";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "portproton";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                export GTK_THEME=Breeze-Dark
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "xash3d";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                bin = "zelda64recomp";
                bin-export = "${bin}-db";
                container = "bazzite-arch-gaming";
              in
              writeShellScriptBin "${bin-export}" ''
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  gamemoderun "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                  gamemoderun distrobox-host-exec '${bin-export}' "$@"
                else
                  '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
                export PULSE_SINK="Game"
                if [ -z "''${CONTAINER_ID}" ]; then
                  exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/usr/bin/${bin}' "$@"
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
            faugus =
              let
                icon = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/Faugus/faugus-launcher/refs/heads/main/faugus-launcher.png";
                  hash = "sha256-NsoIm5jkFp8XVy3egzvRA5+PVISkDKMH5ocd44FOoVk=";
                };
              in
              lib.mkIf cfg.gaming {
                name = "Faugus Launcher";
                comment = "Faugus Launcher";
                exec = "faugus-launcher-db";
                icon = "${icon}";
                categories = [ "Game" ];
              };
            portproton =
              let
                icon = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/Castro-Fidel/PortWINE/refs/heads/devel/data_from_portwine/img/w.png";
                  hash = "sha256-oC18xU2utU6Yoh3sZBsz/kkAeE2ZdQeet87eM3j7VWw=";
                };
              in
              lib.mkIf cfg.gaming {
                name = "PortProton";
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
