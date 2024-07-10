{
  lib,
  config,
  username,
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
          #"io.github.pwr_solaar.solaar"
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
          "org.fooyin.fooyin"
          "org.freedesktop.Platform.ffmpeg-full/x86_64/23.08"
          "org.gtk.Gtk3theme.adw-gtk3-dark"
          "org.gtk.Gtk3theme.Breeze"
          "org.kde.haruna"
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
          "org.fooyin.fooyin" = {
            Context = {
              filesystems = [
                "/mnt/crusader/Media/Audio/Music"
                "~/Music"
              ];
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
    };
  };
}
