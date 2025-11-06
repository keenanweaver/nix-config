{
  lib,
  username,
  pkgs,
  vars,
}:

pkgs.writeShellScriptBin "bootstrap-distrobox" ''
  if [ $(lsb_release -is) == "Arch" ]; then
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
    
    ${lib.optionalString vars.gaming ''
      ### Base packages
      paru -Syu --needed --noconfirm \
      kdialog                        \
      konsole                        \
      lib32-libpulse                 \
      lib32-mangohud                 \
      lib32-openal                   \
      lib32-pipewire                 \
      lib32-pipewire-jack            \
      lib32-vkbasalt                 \
      lib32-vulkan-radeon            \
      libva-mesa-driver              \
      mangohud                       \
      maplemono-nf                   \
      openal                         \
      parui                          \
      pipewire                       \
      pipewire-alsa                  \
      pipewire-jack                  \
      pipewire-pulse                 \
      vkbasalt                       \
      wireplumber                    \
      xdg-desktop-portal-kde

      ## Install necessary packages
      paru -S --needed --noconfirm   \
      archlinux-keyring              \
      base-devel                     \
      yay
    ''}
    
    if [[ "$CONTAINER_ID" =~ ^exodos ]]; then
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
      portproton                   \
      supermarioworld              \
      xash3d-fwgs-git              \
      zeldalttp
      
      # Other steps
      sudo chown -R ${username} /opt/bizhawk
    else 
      echo "Container hostname not found"
    fi
  fi

  if [ $(lsb_release -is) == "Debian" ]; then
    if [[ "$CONTAINER_ID" =~ ^exodos ]]; then
      sudo apt install -y          \
      alsa                         \
      ffmpeg                       \
      kdialog                      \
      konsole                      \
      libnss3                      \
      libslirp0                    \
      lsb-release                  \
      openjdk-21-jre               \
      pipewire                     \
      plasma-desktop               \
      wireplumber

      curl -L -o ~/.cache/dosbox-staging-linux-latest.tar.xz \
      $(curl -s https://api.github.com/repos/dosbox-staging/dosbox-staging/releases/latest \
      | grep "browser_download_url.*linux.*tar.xz" \
      | cut -d '"' -f 4)
    fi
  fi
''
