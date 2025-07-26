{
  lib,
  config,
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
      {
        programs.distrobox = {
          enable = true;
          containers = {
            bazzite-arch-exodos = lib.mkIf cfg.gaming {
              init = true;
              replace = true;
            };
            bazzite-arch-gaming = lib.mkIf cfg.gaming {
              init = true;
              replace = true;
            };
          };
        };
        home = {
          file = {
            config-distrobox-config-file = {
              enable = true;
              text = ''
                container_additional_volumes="/nix/store:/nix/store:ro /etc/static/profiles/per-user:/etc/profiles/per-user:ro"
                container_image_default="ghcr.io/ublue-os/bazzite-arch:latest"
              '';
              target = "${config.xdg.configHome}/distrobox/distrobox.conf";
            };
          };
          packages =
            let
              db-package = config.programs.distrobox.package;
            in
            with pkgs;
            [
              (writeShellApplication {
                name = "bootstrap-baremetal";
                runtimeInputs = [
                  distrobox
                ];
                text = ''
                  distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
                  ${lib.optionalString vars.gaming ''
                    distrobox enter bazzite-arch-exodos -- bash -l -c "bootstrap-distrobox"
                    distrobox enter bazzite-arch-gaming -- bash -l -c "bootstrap-distrobox"
                    script-game-stuff
                  ''}
                '';
              })
              distrobox-tui
            ]
            ++ lib.optionals cfg.gaming [
              (writeShellScriptBin "bootstrap-distrobox" ''
                ## Set paru settings
                if ! grep -q "^SudoLoop" "$XDG_CONFIG_HOME/paru/paru.conf"; then
                  wget -O "$XDG_CONFIG_HOME/paru/paru.conf" https://raw.githubusercontent.com/Morganamilo/paru/master/paru.conf
                  sd '#SudoLoop' 'SudoLoop' "$XDG_CONFIG_HOME/paru/paru.conf"
                  sd '#CleanAfter' 'CleanAfter' "$XDG_CONFIG_HOME/paru/paru.conf"
                  sd '#BottomUp' 'BottomUp' "$XDG_CONFIG_HOME/paru/paru.conf"
                fi
                ## Add Chaotic AUR
                if ! grep -q "chaotic" /etc/pacman.conf; then
                  sudo pacman-key --init
                  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
                  sudo pacman-key --lsign-key 3056513887B78AEB
                  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
                  echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf;
                fi
                ## Set up containers
                ${lib.optionalString vars.gaming ''
                  ### Base packages
                  paru -Syu --needed --noconfirm \
                  kdialog                        \
                  konsole                        \
                  lib32-libpulse                 \
                  lib32-mangohud                 \
                  lib32-vkbasalt                 \
                  lib32-vulkan-radeon            \
                  lib32-openal                   \
                  lib32-pipewire                 \
                  lib32-pipewire-jack            \
                  libva-mesa-driver              \
                  mangohud                       \
                  maplemono-nf                   \
                  openal                         \
                  parui                          \
                  pipewire                       \
                  pipewire-pulse                 \
                  pipewire-alsa                  \
                  pipewire-jack                  \
                  vkbasalt                       \
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
                    dbgl                         \
                    dosbox-staging-git
                  elif [[ "$CONTAINER_ID" =~ ^bazzite-arch-gaming ]]; then
                    # Games/emulators/tools
                    paru -S --needed --noconfirm \
                    archipelagomw-bin            \
                    bizhawk-bin                  \
                    jazzjackrabbit               \
                    lab3d-sdl                    \
                    portproton                   \
                    supermarioworld              \
                    xash3d-fwgs-git              \
                    zeldalttp
                    # Other steps
                    sudo chown -R ${username} /opt/bizhawk
                  else 
                    echo "Container hostname not found"
                  fi
                ''}'')
              (
                let
                  args = "obs-gamecapture mangohud";
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
                  args = "obs-gamecapture mangohud";
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
                  args = "obs-gamecapture mangohud";
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
                  export GTK_THEME=Breeze-Dark
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
                  cd /mnt/crusader/Games/eXo/eXoDOS/exogui
                  if [ -z "''${CONTAINER_ID}" ]; then
                    exec "${db-package}/bin/distrobox-enter" -n ${container} -- ${args} '/mnt/crusader/Games/eXo/eXoDOS/exogui/${bin}' "$@"
                  elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                    exec distrobox-host-exec '${bin-export}' "$@"
                  else
                    exec '/mnt/crusader/Games/eXo/eXoDOS/exogui/${bin}' "$@"
                  fi
                ''
              )
              (
                let
                  args = "obs-gamecapture mangohud";
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
                  args = "obs-gamecapture mangohud";
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
                  args = "obs-gamecapture mangohud";
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
                  args = "obs-gamecapture mangohud";
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
            ];
        };
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
