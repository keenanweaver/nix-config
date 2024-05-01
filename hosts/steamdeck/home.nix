{ config, username, pkgs, ... }:

{

  imports = [
    # Profiles
    ../../modules
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;

  home = {
    packages = with pkgs; [
      /* # System
      dua
      duf
      fd
      killall
      powershell
      repgrep
      unzip
      usbutils
      zip
      vivid*/
      # Fonts
      ibm-plex
      (nerdfonts.override {
        fonts = [ "JetBrainsMono" "IBMPlexMono" "RobotoMono" ];
      })
      roboto
      roboto-serif
    ];
    file = {
      bazzite-enable-mounts = {
        enable = true;
        text = ''
          #!/usr/bin/env bash
          git clone https://codeberg.org/Keenan/home-manager-deck /home/${username}/Downloads
          sudo mkdir -p /var/mnt/crusader && cd /var/mnt/crusader
          sudo mkdir -p /var/mnt/crusader/{Backup,Downloads,eXo,Games,Life,Media,Miscellaneous,Mister,Photos,Projects}
          cd /var/mnt/crusader
          sudo cp /home/${username}/Downloads/home-manager-deck/files/.config/systemd/user/* /etc/systemd/system
          sudo systemctl enable --now                \
          var-mnt-crusader-Backup.automount          \
          var-mnt-crusader-Downloads.automount       \
          var-mnt-crusader-eXo.automount             \
          var-mnt-crusader-Games.automount           \
          var-mnt-crusader-Life.automount            \
          var-mnt-crusader-Media.automount           \
          var-mnt-crusader-Miscellaneous.automount   \
          var-mnt-crusader-Mister.automount          \
          var-mnt-crusader-Photos.automount          \
          var-mnt-crusader-Projects.automount
        '';
        target = ".local/bin/mounts-enable.sh";
        executable = true;
      };
      fonts-jetbrains = {
        enable = true;
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }}/share/fonts/truetype/NerdFonts";
        target = "${config.xdg.dataHome}/fonts/jetbrains-mono";
      };
      script-plasma-nested = {
        enable = true;
        text = ''
          #!/bin/sh
          # Remove the performance overlay, it meddles with some tasks
          unset LD_PRELOAD

          ## Shadow kwin_wayland_wrapper so that we can pass args to kwin wrapper 
          ## whilst being launched by plasma-session
          mkdir $XDG_RUNTIME_DIR/nested_plasma -p
          cat <<EOF > $XDG_RUNTIME_DIR/nested_plasma/kwin_wayland_wrapper
          #!/bin/sh
          /usr/bin/kwin_wayland_wrapper --width 1280 --height 800 --no-lockscreen \$@
          EOF
          chmod a+x $XDG_RUNTIME_DIR/nested_plasma/kwin_wayland_wrapper
          export PATH=$XDG_RUNTIME_DIR/nested_plasma:$PATH

          dbus-run-session startplasma-wayland

          rm $XDG_RUNTIME_DIR/nested_plasma/kwin_wayland_wrapper
        '';
        target = ".local/bin/PlasmaNested.sh";
        executable = true;
      };
    };
  };

}
