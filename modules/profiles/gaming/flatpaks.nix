{ config, ... }:
{
  overrides = {
    global = {
      Context = {
        filesystems = [
          "xdg-config/lsfg-vk:rw"
          "xdg-run/discord-ipc-*"
        ];
      };
      Environment = {
        FLATPAK_GL_DRIVERS = "mesa-git";
        LSFG_CONFIG = "${config.xdg.configHome}/lsfg-vk/conf.toml";
        #PIPEWIRE_NODE = "Game";
        PULSE_SINK = "Game";
      };
    };
    "com.richwhitehouse.BigPEmu" = {
      Context = {
        filesystems = [
          "!home"
        ];
      };
    };
    "dev.opengoal.OpenGOAL" = {
      Context = {
        filesystems = [ "${config.home.homeDirectory}/Games/opengoal" ];
      };
    };
    "info.cemu.Cemu" = {
      Context = {
        filesystems = [
          "${config.home.homeDirectory}/Games/cemu"
        ];
      };
    };
    "info.exult.exult" = {
      Context = {
        filesystems = [
          "${config.home.homeDirectory}/Music/soundfonts:ro"
        ];
      };
    };
    "io.github.ryubing.Ryujinx" = {
      Context = {
        filesystems = [
          "!home"
          "${config.home.homeDirectory}/Games/switch"
        ];
      };
    };
    "io.github.strikerx3.ymir" = {
      Context = {
        filesystems = [
          "/mnt/crusader/Games/Rom/CHD/Sega Saturn"
          "/mnt/crusader/Games/Mister/Saturn"
        ];
      };
    };
    "net.fsuae.FS-UAE" = {
      Context = {
        filesystems = [
          "!home"
        ];
      };
    };
    "net.kuribo64.melonDS" = {
      Context = {
        filesystems = [
          "!home"
          "/mnt/crusader/Games/Backups/Myrient/No-Intro"
        ];
      };
    };
    "net.pcsx2.PCSX2" = {
      Context = {
        filesystems = [
          "host"
          "/mnt/crusader/Games/Rom/CHD/Sony Playstation 2"
        ];
      };
    };
    "net.rpcs3.RPCS3" = {
      Context = {
        filesystems = [
          "!home"
          "${config.home.homeDirectory}/Games/roms/rpcs3"
        ];
      };
    };
    "org.azahar_emu.Azahar" = {
      Context = {
        filesystems = [
          "${config.home.homeDirectory}/Games/3ds"
        ];
      };
    };
    "org.DolphinEmu.dolphin-emu" = {
      Context = {
        filesystems = [
          "/mnt/crusader/Games/Rom/CHD/Nintendo GameCube"
        ];
      };
    };
    "org.easyrpg.player" = {
      Context = {
        filesystems = [
          "${config.home.homeDirectory}/Music/soundfonts:ro"
          "${config.home.homeDirectory}/Games/rpg-maker"
          "!home"
          "!host"
        ];
        shared = "network"; # obs-gamecapture
      };
      Environment = {
        RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
        RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
      };
    };
    "org.flycast.Flycast" = {
      Context = {
        filesystems = [
          "/mnt/crusader/Games/Rom/CHD/Sega Dreamcast"
        ];
      };
    };
    "org.mamedev.MAME" = {
      Context = {
        filesystems = [
          "/mnt/crusader/Games/Rom/Other/MAME"
          "!home"
        ];
      };
    };
  };
  packages = [
    "app.xemu.xemu"
    "com.fightcade.Fightcade"
    "com.fightcade.Fightcade.Wine"
    "com.github.optyfr.JRomManager"
    "com.qzandronum.Q-Zandronum"
    "com.richwhitehouse.BigPEmu"
    "com.supermodel3.Supermodel"
    "dev.ares.ares"
    "dev.opengoal.OpenGOAL"
    "info.beyondallreason.bar"
    "info.cemu.Cemu"
    "info.exult.exult"
    {
      appId = "io.github.hedge_dev.unleashedrecomp";
      bundle = "file://${config.home.homeDirectory}/Games/io.github.hedge_dev.unleashedrecomp.flatpak";
      sha256 = "13wca95yngfwl1y0c05y0b2w7aa8k3nkhvk46wsrxjvw3shb35im";
    }
    "io.github.randovania.Randovania"
    "io.github.ryubing.Ryujinx"
    "io.github.strikerx3.ymir"
    "net.fsuae.FS-UAE"
    "net.kuribo64.melonDS"
    "net.nmlgc.rec98.sh01"
    {
      appId = "net.pcsx2.PCSX2";
      origin = "flathub-beta";
    }
    "net.rpcs3.RPCS3"
    "net.sourceforge.uqm_mods.UQM-MegaMod"
    "org.azahar_emu.Azahar"
    "org.diasurgical.DevilutionX"
    "org.DolphinEmu.dolphin-emu"
    "org.flycast.Flycast"
    "org.freedesktop.Platform.VulkanLayer.lsfgvk/x86_64/24.08"
    "org.freedesktop.Platform.VulkanLayer.lsfgvk/x86_64/25.08"
    {
      appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/25.08";
      origin = "flathub-beta";
    }
    {
      appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/25.08";
      origin = "flathub-beta";
    }
    {
      appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/24.08";
      origin = "flathub-beta";
    }
    {
      appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/24.08";
      origin = "flathub-beta";
    }
    "org.kartkrew.RingRacers"
    "org.mamedev.MAME"
    "org.openfodder.OpenFodder"
    "org.openjkdf2.OpenJKDF2"
    "org.pegasus_frontend.Pegasus"
    "org.ppsspp.PPSSPP"
    "org.sonic3air.Sonic3AIR"
    "org.srb2.SRB2"
    "vet.rsc.OpenRSC.Launcher"
  ];
}
