{
  configurations.nixos.nixos-desktop.module = { config, ... }: {
    home-manager.users.${config.my.user} = { config, ... }: {
      services.ludusavi = {
        settings = {
          backup.path = "/mnt/games/ludusavi";
          customGames = [
            {
              files = [
                "${config.xdg.dataHome}/bibendovsky/bstone/*saved_game*"
              ];
              name = "Blake Stone";
            }
            {
              files = [
                "${config.xdg.configHome}/CorsixTH/Saves/*.sav"
              ];
              name = "CorsixTH";
            }
            {
              files = [
                "${config.xdg.dataHome}/Daikatana/data/save_x64"
              ];
              name = "Daikatana";
            }
            {
              files = [
                "${config.xdg.dataHome}/diasurgical/devilution/*.sv"
              ];
              name = "DevilutionX";
            }
            {
              files = [
                "${config.xdg.dataHome}/dolphin-emu/StateSaves"
                "${config.home.homeDirectory}/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/StateSaves"
              ];
              name = "Dolphin-Emu";
            }
            {
              files = [
                "${config.xdg.dataHome}/cherry-doom/savegames"
                "${config.xdg.dataHome}/chocolate-doom/savegames"
                "${config.xdg.dataHome}/chocolate-heretic/savegames"
                "${config.xdg.dataHome}/chocolate-hexen/savegames"
                "${config.xdg.dataHome}/crispy-doom/savegames"
                "${config.xdg.dataHome}/crispy-heretic/savegames"
                "${config.xdg.dataHome}/crispy-hexen/savegames"
                "${config.xdg.dataHome}/nugget-doom/savegames"
                "${config.xdg.dataHome}/uzdoom/savegames"
                "${config.xdg.dataHome}/woof/savegames"
              ];
              name = "Doom";
            }
            {
              files = [
                "${config.xdg.dataHome}/dhewm3/base/savegames"
                "${config.xdg.dataHome}/rbdoom3bfg/base/savegame"
              ];
              name = "Doom 3";
            }
            {
              files = [
                "${config.xdg.configHome}/duckstation/memcards"
                "${config.xdg.configHome}/duckstation/savestates"
                "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/memcards"
                "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/savestates"
              ];
              name = "Duckstation";
            }
            {
              files = [
                "${config.xdg.configHome}/eduke32/*.esv"
                "${config.xdg.configHome}/raze/savegames"
              ];
              name = "Duke3D";
            }
            {
              files = [
                "${config.xdg.dataHome}/ecwolf/savegames"
              ];
              name = "ECWolf";
            }
            {
              files = [
                "${config.home.homeDirectory}/.var/app/info.exult.exult/data/forgeofvirtue/save/*.sav"
                "${config.home.homeDirectory}/.var/app/info.exult.exult/data/silverseed/save/*.sav"
              ];
              name = "Exult";
            }
            {
              files = [
                "${config.home.homeDirectory}/.alephone/Quick Saves"
                "${config.home.homeDirectory}/.alephone/Saved Games"
              ];
              name = "Marathon";
            }
            {
              files = [
                "${config.xdg.dataHome}/openmw/saves"
              ];
              name = "OpenMW";
            }
            {
              files = [
                "${config.xdg.configHome}/PCSX2/memcards"
                "${config.xdg.configHome}/PCSX2/sstates"
                "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/memcards"
                "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/sstates"
              ];
              name = "PCSX2";
            }
            {
              files = [
                "${config.xdg.dataHome}/scummvm/saves"
                "${config.home.homeDirectory}/.var/app/org.scummvm.ScummVM/data/scummvm/saves"
              ];
              name = "ScummVM";
            }
            {
              files = [
                "${config.xdg.dataHome}/soh/Save"
              ];
              name = "Ship of Harkinian";
            }
            {
              files = [
                "${config.xdg.dataHome}/sm64ex/sm64_save*"
              ];
              name = "SM64EX";
            }
            {
              files = [
                "${config.xdg.dataHome}/TheForceEngine/Saves"
              ];
              name = "The Force Engine";
            }
            {
              files = [
                "${config.xdg.dataHome}/phoboslab/wipeout/save*"
              ];
              name = "Wipeout";
            }
          ];
          restore = {
            path = "${config.home.homeDirectory}/Games/games/ludusavi";
          };
        };
      };
    };
  };
}
