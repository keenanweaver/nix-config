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
          # Desktop-only
          db-aaru = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/aaru"; target = "${dbe}/aaru"; executable = true; };
          #db-bstone = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/bstone"; target = "${dbe}/bstone"; executable = true; };
          #db-chocolate-doom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/chocolate-doom"; target = "${dbe}/chocolate-doom"; executable = true; };
          #db-crispy-doom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/crispy-doom"; target = "${dbe}/crispy-doom"; executable = true; };
          #db-crispy-heretic = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/crispy-heretic"; target = "${dbe}/crispy-heretic"; executable = true; };
          #db-crispy-hexen = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/crispy-hexen"; target = "${dbe}/crispy-hexen"; executable = true; };
          db-dbgl = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/dbgl"; target = "${dbe}/dbgl"; executable = true; };
          #db-doomseeker = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/doomseeker"; target = "${dbe}/doomseeker"; executable = true; };
          #db-dsda-doom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/dsda-doom"; target = "${dbe}/dsda-doom"; executable = true; };
          #db-ecwolf = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/ecwolf"; target = "${dbe}/ecwolf"; executable = true; };
          db-exogui = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/exogui"; target = "${dbe}/exogui"; executable = true; };
          #db-gzdoom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/gzdoom"; target = "${dbe}/gzdoom"; executable = true; };
          #db-ironwail = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/ironwail"; target = "${dbe}/ironwail"; executable = true; };
          db-lab3d-sdl = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/lab3d-sdl"; target = "${dbe}/lab3d-sdl"; executable = true; };
          #db-nsz = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/nsz"; target = "${dbe}/nsz"; executable = true; };
          db-obs-gamecapture = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/obs-gamecapture"; target = "${dbe}/obs-gamecapture-db"; executable = true; };
          db-openxcom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/openxcom"; target = "${dbe}/openxcom"; executable = true; };
          #db-portproton = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/portproton"; target = "${dbe}/portproton"; executable = true; };
          #db-prboom-plus = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/prboom-plus"; target = "${dbe}/prboom-plus"; executable = true; };
          #db-quake3e = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/quake3e"; target = "${dbe}/quake3e"; executable = true; };
          #db-sm64ex-nightly = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/sm64ex-nightly"; target = "${dbe}/sm64ex-nightly"; executable = true; };
          #db-soh = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/soh"; target = "${dbe}/soh"; executable = true; };
          db-sonic-1 = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/sonic-1"; target = "${dbe}/sonic-1"; executable = true; };
          db-sonic-2 = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/sonic-2"; target = "${dbe}/sonic-2"; executable = true; };
          #db-trenchbroom = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/trenchbroom"; target = "${dbe}/trenchbroom"; executable = true; };
          #db-xash3d = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/xash3d"; target = "${dbe}/xash3d"; executable = true; };
          #db-zandronum = { enable = true; source = config.lib.file.mkOutOfStoreSymlink "${dbs}/zandronum"; target = "${dbe}/zandronum"; executable = true; };
          # Others
          db-nccm = { source = config.lib.file.mkOutOfStoreSymlink "${dbs}/nccm"; target = "${dbe}/nccm"; executable = true; };
          db-qobuz-dl = { source = config.lib.file.mkOutOfStoreSymlink "${dbs}/qobuz-dl"; target = "${dbe}/qobuz-dl"; executable = true; };
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
              #echo '[[ $- == *i* ]] && source /usr/share/blesh/ble.sh' >> ${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.bashrc
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
              #echo '[[ $- == *i* ]] && source /usr/share/blesh/ble.sh' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.bashrc
              echo 'eval "$(atuin init bash)"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.bashrc
              echo 'db_path = "/home/${username}/.local/share/atuin/history.db"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/atuin/config.toml
              echo 'key_path = "/home/${username}/.local/share/atuin/key"' >> ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.config/atuin/config.toml
              paru -Syu --needed --noconfirm base-devel gamescope gamemode kdialog micro pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber #plasma-desktop
              paru -R steam lutris
              ### Download game stuff
              #paru -S --noconfirm sm64ex-nightly-git soh soh-otr-n64_pal_11
              #wget 'https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Legend%20of%20Zelda%2C%20The%20-%20Ocarina%20of%20Time%20%28Europe%29%20%28En%2CFr%2CDe%29%20%28Rev%201%29.zip' -P /home/${username}/Games
              #wget 'https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Super%20Mario%2064%20%28USA%29.zip' -P /home/${username}/Games
              #unzip '/home/${username}/Games/Legend of Zelda, The - Ocarina of Time (Europe) (En,Fr,De) (Rev 1).zip' -j 'Legend of Zelda, The - Ocarina of Time (Europe) (En,Fr,De) (Rev 1).z64' -d ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/soh-otr-n64_pal_11 ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/sm64ex-nightly-git
              #mv '${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/soh-otr-n64_pal_11/Legend of Zelda, The - Ocarina of Time (Europe) (En,Fr,De) (Rev 1).z64' ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/soh-otr-n64_pal_11/baserom.z64
              #unzip '/home/${username}/Games/Super Mario 64 (USA).zip' -j 'Super Mario 64 (USA).z64' -d ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/sm64ex-nightly-git
              #mv '${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/sm64ex-nightly-git/Super Mario 64 (USA).z64' ${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.cache/paru/clone/sm64ex-nightly-git/baserom.us.z64
              ### Install game stuff
              paru -S --needed --noconfirm aaru lab3d-sdl openxcom-extended rsdkv4-bin xash3d-fwgs-git
              #bstone chocolate-doom crispy-doom doomseeker dsda-doom ecwolf-git gzdoom ironwail nsz python-kivy prboom-plus quake3e-git ryusak sm64ex-nightly-git soh soh-otr-n64_pal_11 trenchbroom-git zandronum
              paru -Scc --noconfirm
              ### Post-install stuff
              grep ${username} /etc/passwd | sudo sed -i 's/\/usr\/sbin\/zsh/\/usr\/bin\/bash/g' /etc/passwd
              #distrobox-export --app lutris
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
          /*         distrobox-bazzite-arch-gaming-icons = {
          enable = false;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.icons";
          target = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/.icons";
          }; */
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
              #echo '[[ $- == *i* ]] && source /usr/share/blesh/ble.sh' >> ${config.xdg.configHome}/distrobox/bazzite-arch-sys/.bashrc
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
