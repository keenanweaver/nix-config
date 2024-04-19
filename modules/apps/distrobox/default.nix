{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.distrobox;
in
{
  options = {
    distrobox = {
      enable = mkEnableOption "Enable distrobox in NixOS & home-manager";
      gaming = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        distrobox_git
      ];
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, dotfiles, ... }:
      let
        dbe = "${config.xdg.dataHome}/distrobox/exports/bin";
        dbs = "${dotfiles}/distrobox";
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
          db-dbgl =
            let
              args = "obs-gamecapture mangohud";
              bin = "dbgl";
              container = "bazzite-arch-exodos";
            in
            {
              enable = true;
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
              enable = true;
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
          db-lab3d-sdl =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "lab3d-sdl";
              container = "bazzite-arch-gaming";
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
          db-sonic-1 =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "RSDKv4";
              container = "bazzite-arch-gaming";
            in
            {
              enable = true;
              text = ''
                #!/usr/bin/env bash
                cd ${config.xdg.configHome}/distrobox/${container}/.config/SonicTheHedgehog || exit
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/sonic-1";
              executable = true;
            };
          db-sonic-2 =
            let
              args = "gamemoderun obs-gamecapture mangohud";
              bin = "RSDKv4";
              container = "bazzite-arch-gaming";
            in
            {
              enable = true;
              text = ''
                #!/usr/bin/env bash
                cd ${config.xdg.configHome}/distrobox/${container}/.config/SonicTheHedgehog2 || exit
                if [ -z "''${CONTAINER_ID}" ]; then
                	exec "/run/current-system/sw/bin/distrobox-enter" -n ${container} -- ${args} /usr/bin/${bin}  "$@"
                elif [ -n "''${CONTAINER_ID}" ] && [ "''${CONTAINER_ID}" != "${container}" ]; then
                	exec distrobox-host-exec /home/${username}/.local/share/distrobox/exports/bin/${bin}  "$@"
                else
                	exec /usr/bin/${bin} "$@"
                fi
              '';
              target = "${dbe}/sonic-2";
              executable = true;
            };
          distrobox-assemble-desktop = {
            enable = true;
            recursive = false;
            text = ''
              [bazzite-arch-sys]
              home=${config.xdg.configHome}/distrobox/bazzite-arch-sys
              image=ghcr.io/ublue-os/bazzite-arch:latest
              init=true
              pull=false
              replace=false
              start_now=true

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
            '';
            target = "${config.xdg.configHome}/distrobox/distrobox.ini";
          };
          distrobox-bazzite-arch-exodos = {
            enable = true;
            recursive = false;
            text = ''
              #!/usr/bin/env bash
              ### Set up pacman/paru settings
              sudo pacman-key --init
              sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
              sudo pacman-key --lsign-key 3056513887B78AEB
              sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
              sudo bash -c "{ echo '[chaotic-aur]'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'Include = /etc/pacman.d/chaotic-mirrorlist'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'en_US.UTF-8 UTF-8'; } >> /etc/locale.gen"
              paru -Syu --noconfirm reflector
              sudo sed -i -e 's/# --country France,Germany/--country US/g' /etc/xdg/reflector/reflector.conf
              sudo systemctl enable --now reflector.timer
              sudo systemctl start reflector.service
              mkdir -p ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/paru
              wget https://raw.githubusercontent.com/Morganamilo/paru/master/paru.conf -O ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/paru/paru.conf
              sed -i -e 's/#SudoLoop/SudoLoop/g' -e 's/#BottomUp/BottomUp/g' -e 's/#CleanAfter/CleanAfter/g' ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/paru/paru.conf
              ### Install base packages
              paru -R --noconfirm xcursor-breeze
              paru -S --noconfirm archlinux-keyring
              paru -Syu --needed --noconfirm base-devel
              paru -S --noconfirm --needed atuin blesh yay
              echo 'eval "$(atuin init bash)"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.bashrc
              echo 'db_path = "/home/${username}/.local/share/atuin/history.db"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/atuin/config.toml
              echo 'key_path = "/home/${username}/.local/share/atuin/key"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/atuin/config.toml
              paru -Syu --needed --noconfirm dbgl gamemode pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber #plasma-desktop
              paru -S --needed --noconfirm fluidsynth gwenview innoextract konsole okular
              paru -Scc --noconfirm
              ### Post-install stuff
              grep ${username} /etc/passwd | sudo sed -i 's/\/usr\/sbin\/zsh/\/usr\/bin\/bash/g' /etc/passwd
            '';
            target = "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-exodos.sh";
            executable = true;
          };
          distrobox-bazzite-arch-exodos-catppuccin-konsole = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.catppuccin-konsole}/Catppuccin-Mocha.colorscheme";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/konsole/Catppuccin-Mocha.colorscheme";
          };
          distrobox-bazzite-arch-exodos-gtk2 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-2.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-2.0";
          };
          distrobox-bazzite-arch-exodos-gtk3 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-3.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-3.0";
          };
          distrobox-bazzite-arch-exodos-gtk4 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-4.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/gtk-4.0";
          };
          distrobox-bazzite-arch-exodos-kdeglobals = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/kdeglobals";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/kdeglobals";
          };
          distrobox-bazzite-arch-exodos-konsole = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/konsole/${username}.profile";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/konsole/${username}.profile";
          };
          distrobox-bazzite-arch-exodos-themes = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/themes";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.local/share/themes";
          };
          distrobox-bazzite-arch-exodos-trolltech = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/Trolltech.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/Trolltech.conf";
          };
          distrobox-bazzite-arch-gaming = {
            enable = true;
            recursive = false;
            text = ''
              #!/usr/bin/env bash
              ### Set pacman/paru settings
              sudo pacman-key --init
              sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
              sudo pacman-key --lsign-key 3056513887B78AEB
              sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
              sudo bash -c "{ echo '[chaotic-aur]'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'Include = /etc/pacman.d/chaotic-mirrorlist'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'en_US.UTF-8 UTF-8'; } >> /etc/locale.gen"
              paru -Syu --noconfirm reflector
              sudo sed -i -e 's/# --country France,Germany/--country US/g' /etc/xdg/reflector/reflector.conf
              sudo systemctl enable --now reflector.timer
              sudo systemctl start reflector.service
              mkdir -p ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/paru
              wget https://raw.githubusercontent.com/Morganamilo/paru/master/paru.conf -O ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/paru/paru.conf
              sed -i -e 's/#SudoLoop/SudoLoop/g' -e 's/#BottomUp/BottomUp/g' -e 's/#CleanAfter/CleanAfter/g' ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/paru/paru.conf
              ### Install base packages
              paru -R --noconfirm xcursor-breeze
              paru -S --noconfirm archlinux-keyring
              paru -S --noconfirm --needed atuin blesh yay
              echo 'eval "$(atuin init bash)"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.bashrc
              echo 'db_path = "/home/${username}/.local/share/atuin/history.db"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/atuin/config.toml
              echo 'key_path = "/home/${username}/.local/share/atuin/key"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/atuin/config.toml
              paru -Syu --needed --noconfirm base-devel gamescope gamemode kdialog micro pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber #plasma-desktop
              paru -R steam lutris
              ### Download game stuff
              paru -S --needed --noconfirm aaru lab3d-sdl openxcom-extended rsdkv4-bin xash3d-fwgs-git
              paru -Scc --noconfirm
              ### Post-install stuff
              grep ${username} /etc/passwd | sudo sed -i 's/\/usr\/sbin\/zsh/\/usr\/bin\/bash/g' /etc/passwd
            '';
            target = "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-gaming.sh";
            executable = true;
          };
          distrobox-bazzite-arch-gaming-gtk2 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-2.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-2.0";
          };
          distrobox-bazzite-arch-gaming-gtk3 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-3.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-3.0";
          };
          distrobox-bazzite-arch-gaming-gtk4 = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/gtk-4.0";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/gtk-4.0";
          };
          distrobox-bazzite-arch-gaming-kdeglobals = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/kdeglobals";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/kdeglobals";
          };
          distrobox-bazzite-arch-gaming-konsole = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/konsole/${username}.profile";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.local/share/konsole/${username}.profile";
          };
          distrobox-bazzite-arch-gaming-themes = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/themes";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.local/share/themes";
          };
          distrobox-bazzite-arch-gaming-trolltech = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/Trolltech.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/Trolltech.conf";
          };
          distrobox-mangohud-gaming = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/MangoHud/MangoHud.conf";
          };
          distrobox-mangohud-exodos = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/MangoHud/MangoHud.conf";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/MangoHud/MangoHud.conf";
          };
          distrobox-bazzite-arch-sys = {
            enable = true;
            recursive = false;
            text = ''
              #!/usr/bin/env bash
              ### Set pacman/paru settings
              sudo pacman-key --init
              sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
              sudo pacman-key --lsign-key 3056513887B78AEB
              sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
              sudo bash -c "{ echo '[chaotic-aur]'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'Include = /etc/pacman.d/chaotic-mirrorlist'; } >> /etc/pacman.conf"
              sudo bash -c "{ echo 'en_US.UTF-8 UTF-8'; } >> /etc/locale.gen"
              paru -Syu --noconfirm reflector
              sudo sed -i -e 's/# --country France,Germany/--country US/g' /etc/xdg/reflector/reflector.conf
              sudo systemctl enable --now reflector.timer
              sudo systemctl start reflector.service
              mkdir -p ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/paru
              wget https://raw.githubusercontent.com/Morganamilo/paru/master/paru.conf -O ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/paru/paru.conf
              sed -i -e 's/#SudoLoop/SudoLoop/g' -e 's/#BottomUp/BottomUp/g' -e 's/#CleanAfter/CleanAfter/g' ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/paru/paru.conf
              ### Install base packages
              paru -R --noconfirm xcursor-breeze
              paru -S --noconfirm archlinux-keyring
              paru -Syu --needed --noconfirm base-devel
              paru -S --noconfirm --needed atuin blesh yay
              echo 'eval "$(atuin init bash)"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.bashrc
              echo 'db_path = "/home/${username}/.local/share/atuin/history.db"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/atuin/config.toml
              echo 'key_path = "/home/${username}/.local/share/atuin/key"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/atuin/config.toml
              paru -S --needed --noconfirm nccm python-pipx
              pipx install qobuz-dl
              paru -Scc --noconfirm
              ### Post-install stuff
              grep ${username} /etc/passwd | sudo sed -i 's/\/usr\/sbin\/zsh/\/usr\/bin\/bash/g' /etc/passwd
            '';
            target = "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-sys.sh";
            executable = true;
          };
          nccm = {
            enable = true;
            recursive = false;
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nccm/nccm.yml";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-sys/.config/nccm/nccm.yml";
          };
        };
        home.packages = with pkgs; [ xorg.xhost ];
      };
  };
}
