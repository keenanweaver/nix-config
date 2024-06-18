{
  lib,
  config,
  username,
  dotfiles,
  pkgs,
  ...
}:
let
  cfg = config.flatpak;
in
{

  imports = [ ./flatpak-fix.nix ];

  options = {
    flatpak = {
      enable = lib.mkEnableOption "Enable flatpak in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      flatpak = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ flatpak-builder ];

    systemd.services = {
      "home-manager-${username}" = {
        serviceConfig.TimeoutStartSec = pkgs.lib.mkForce 1200;
      };
    };

    users.users.${username}.extraGroups = [ "flatpak" ];

    xdg.portal.enable = true;

    home-manager.users.${username} = {
      services.flatpak = {
        #uninstallUnmanaged = true;
        packages = [
          #"chat.revolt.RevoltDesktop"
          #"com.bitwig.BitwigStudio"
          #"com.felipekinoshita.Wildcard"
          "com.georgefb.mangareader"
          "com.github.tchx84.Flatseal"
          #"com.logseq.Logseq"
          #"com.makemkv.MakeMKV"
          "com.obsproject.Studio"
          #"com.ranfdev.Notify"
          #"fr.handbrake.ghb"
          "fr.romainvigier.MetadataCleaner"
          #"im.riot.Riot"
          #"io.github.btpf.alexandria"
          #"io.github.dvlv.boxbuddyrs"
          #"io.github.eteran.edb-debugger"
          #"io.github.jonmagon.kdiskmark"
          "io.github.pwr_solaar.solaar"
          #"io.github.seadve.Breathing"
          #"io.github.seadve.Mousai"
          "io.github.ungoogled_software.ungoogled_chromium"
          #"io.gitlab.gregorni.Letterpress"
          #"io.gpt4all.gpt4all"
          #"io.mpv.Mpv"
          "it.mijorus.gearlever"
          #"net.mediaarea.MediaInfo"
          "net.mullvad.MullvadBrowser"
          #"network.loki.Session"
          "no.mifi.losslesscut"
          "one.ablaze.floorp"
          #"org.bleachbit.BleachBit"
          #"org.bunkus.mkvtoolnix-gui"
          "org.filezillaproject.Filezilla"
          #"org.fooyin.fooyin"
          "org.freedesktop.Platform.ffmpeg-full/x86_64/23.08"
          "org.kde.haruna"
          "org.kde.isoimagewriter"
          "org.kde.kdenlive"
          "org.kde.krita"
          "org.kde.neochat"
          "org.kde.tokodon"
          #"org.mozilla.firefox"
          "org.musicbrainz.Picard"
          #"org.nickvision.tagger"
          "org.onlyoffice.desktopeditors"
          "org.rncbc.qpwgraph"
          "org.signal.Signal"
          "org.squidowl.halloy"
          #"org.strawberrymusicplayer.strawberry"
          #"org.tildearrow.furnace"
          "xyz.armcord.ArmCord"
        ];
        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
          {
            name = "flathub-beta";
            location = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
          }
        ];
        #update.auto.enable = true;
        overrides = {
          global = {
            Context = {
              filesystems = [
                "/home/${username}/.icons:ro"
                "/home/${username}/.themes:ro"
                "/nix/store:ro"
                "/run/media/${username}:ro"
                "xdg-data/themes:ro"
                "xdg-data/icons:ro"
                "xdg-config/gtkrc:ro"
                "xdg-config/gtkrc-2.0:ro"
                "xdg-config/gtk-2.0:ro"
                "xdg-config/gtk-3.0:ro"
                "xdg-config/gtk-4.0:ro"
                "xdg-config/MangoHud:ro"
                "xdg-run/.flatpak/com.xyz.armcord.ArmCord:create"
                "xdg-run/discord-ipc-*"
              ];
            };
          };
          "com.georgefb.mangareader" = {
            Context = {
              filesystems = [
                "/mnt/crusader/Downloads/Torrents/F"
                "!home"
              ];
            };
          };
          "com.github.Alcaro.Flips" = {
            Context = {
              filesystems = [ "!home" ];
            };
          };
          "com.rustdesk.RustDesk" = {
            Context = {
              filesystems = [ "!home" ];
            };
          };
          "it.mijorus.gearlever" = {
            Context = {
              filesystems = [ "/home/${username}/.local/bin" ];
            };
          };
          "net.mediaarea.MediaInfo" = {
            Context = {
              filesystems = [ "!home" ];
            };
          };
          "one.ablaze.floorp" = {
            Environment = {
              MOZ_ENABLE_WAYLAND = "1";
            };
          };
          "org.kde.haruna" = {
            Context = {
              filesystems = [ "!home" ];
            };
          };
          "org.musicbrainz.Picard" = {
            Context = {
              filesystems = [
                "/mnt/crusader/Media/Audio/Music"
                "!home"
                "xdg-download"
                "~/Music"
              ];
            };
          };
          "org.nickvision.tagger" = {
            Context = {
              filesystems = [ "!home" ];
            };
          };
          "org.signal.Signal" = {
            Context = {
              filesystems = [
                "!xdg-public-share"
                "!xdg-videos"
                "!xdg-pictures"
                "!xdg-download"
                "!xdg-music"
                "!xdg-desktop"
                "!xdg-documents"
              ];
            };
          };
        };
      };
      /*
        home.file = {
               flatpak-overrides-global = {
                 enable = true;
                 text = ''
                   [Context]
                   filesystems=/run/media/${username}:ro;/home/${username}/.icons:ro;/home/${username}/.themes:ro;xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;xdg-run/.flatpak/com.xyz.armcord.ArmCord:create;xdg-run/discord-ipc-*;xdg-config/MangoHud:ro;/nix/store:ro
                 '';
                 target = "${config.xdg.dataHome}/flatpak/overrides/global";
               };
               script-flatpak-install-all = {
                 enable = true;
                 text = ''
                   #!/usr/bin/env bash
                   /home/${username}/.local/bin/flatpak-install-sys.sh
                   /home/${username}/.local/bin/flatpak-install.sh
                   /home/${username}/.local/bin/flatpak-install-games.sh
                 '';
                 target = ".local/bin/flatpak-install-all.sh";
                 executable = true;
               };
               script-flatpak-install = {
                 enable = true;
                 text = ''
                   #!/usr/bin/env bash
                   < /home/${username}/.local/bin/.flatpak xargs flatpak install --user --assumeyes
                 '';
                 target = ".local/bin/flatpak-install.sh";
                 executable = true;
               };
               script-flatpak-install-games = {
                 enable = vars.gaming;
                 text = ''
                   #!/usr/bin/env bash
                   < /home/${username}/.local/bin/.flatpak-games xargs flatpak install --user --assumeyes
                 '';
                 target = ".local/bin/flatpak-install-games.sh";
                 executable = true;
               };
               script-flatpak-install-beta = {
                 enable = true;
                 text = ''
                   #!/usr/bin/env bash
                   < /home/${username}/.local/bin/.flatpak-beta xargs flatpak install --user --assumeyes
                 '';
                 target = ".local/bin/flatpak-install-beta.sh";
                 executable = true;
               };
               script-flatpak-install-sys = {
                 enable = true;
                 text = ''
                   #!/usr/bin/env bash
                   < /home/${username}/.local/bin/.flatpak-sys xargs flatpak install --system --assumeyes
                 '';
                 target = ".local/bin/flatpak-install-sys.sh";
                 executable = true;
               };
             };
      */
    };
  };
}
