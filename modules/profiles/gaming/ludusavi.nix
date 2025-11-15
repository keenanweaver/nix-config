{ config, ... }:
{
  enable = true;
  backupNotification = true;
  settings = {
    backup = {
      path = "${config.home.homeDirectory}/Games/games/ludusavi";
      format = {
        chosen = "zip";
        zip.compression = "deflate";
      };
    };
    customGames = [
      {
        name = "Blake Stone";
        files = [
          "${config.xdg.dataHome}/bibendovsky/bstone/*saved_game*"
        ];
      }
      {
        name = "CorsixTH";
        files = [
          "${config.xdg.configHome}/CorsixTH/Saves/*.sav"
        ];
      }
      {
        name = "Daikatana";
        files = [
          "${config.xdg.dataHome}/Daikatana/data/save_x64"
        ];
      }
      {
        name = "DevilutionX";
        files = [
          "${config.xdg.dataHome}/diasurgical/devilution/*.sv"
        ];
      }
      {
        name = "Dolphin-Emu";
        files = [
          "${config.xdg.dataHome}/dolphin-emu/StateSaves"
          "${config.home.homeDirectory}/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/StateSaves"
        ];
      }
      {
        name = "Doom";
        files = [
          "${config.xdg.dataHome}/cherry-doom/savegames"
          "${config.xdg.dataHome}/chocolate-doom/savegames"
          "${config.xdg.dataHome}/chocolate-heretic/savegames"
          "${config.xdg.dataHome}/chocolate-hexen/savegames"
          "${config.xdg.dataHome}/crispy-doom/savegames"
          "${config.xdg.dataHome}/crispy-heretic/savegames"
          "${config.xdg.dataHome}/crispy-hexen/savegames"
          "${config.xdg.dataHome}/doom64ex-minus/*.dsg"
          "${config.xdg.dataHome}/nugget-doom/savegames"
          "${config.xdg.dataHome}/woof/savegames"
          "${config.xdg.configHome}/uzdoom/savegames"
        ];
      }
      {
        name = "Doom 3";
        files = [
          "${config.xdg.dataHome}/dhewm3/base/savegames"
          "${config.xdg.dataHome}/rbdoom3bfg/base/savegame"
        ];
      }
      {
        name = "Duckstation";
        files = [
          "${config.xdg.configHome}/duckstation/memcards"
          "${config.xdg.configHome}/duckstation/savestates"
          "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/memcards"
          "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/savestates"
        ];
      }
      {
        name = "Duke3D";
        files = [
          "${config.xdg.configHome}/eduke32/*.esv"
          "${config.xdg.configHome}/raze/savegames"
        ];
      }
      {
        name = "ECWolf";
        files = [
          "${config.xdg.dataHome}/ecwolf/savegames"
        ];
      }
      {
        name = "Exult";
        files = [
          "${config.home.homeDirectory}/.var/app/info.exult.exult/data/forgeofvirtue/save/*.sav"
          "${config.home.homeDirectory}/.var/app/info.exult.exult/data/silverseed/save/*.sav"
        ];
      }
      {
        name = "OpenMW";
        files = [
          "${config.xdg.dataHome}/openmw/saves"
        ];
      }
      {
        name = "PCSX2";
        files = [
          "${config.xdg.configHome}/PCSX2/memcards"
          "${config.xdg.configHome}/PCSX2/sstates"
          "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/memcards"
          "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/sstates"
        ];
      }
      {
        name = "ScummVM";
        files = [
          "${config.xdg.dataHome}/scummvm/saves"
          "${config.home.homeDirectory}/.var/app/org.scummvm.ScummVM/data/scummvm/saves"
        ];
      }
      {
        name = "Ship of Harkinian";
        files = [
          "${config.xdg.dataHome}/soh/Save"
        ];
      }
      {
        name = "SM64EX";
        files = [
          "${config.xdg.dataHome}/sm64ex/sm64_save*"
        ];
      }
      {
        name = "The Force Engine";
        files = [
          "${config.xdg.dataHome}/TheForceEngine/Saves"
        ];
      }
      {
        name = "Wipeout";
        files = [
          "${config.xdg.dataHome}/phoboslab/wipeout/save*"
        ];
      }
    ];
    restore = {
      path = "${config.home.homeDirectory}/Games/games/ludusavi";
    };
    roots = [
      {
        path = "${config.xdg.configHome}/heroic";
        store = "heroic";
      }
      {
        path = "${config.home.homeDirectory}/Games/Heroic";
        store = "heroic";
      }
      {
        path = "${config.xdg.dataHome}/lutris";
        store = "lutris";
      }
      {
        path = "${config.home.homeDirectory}/Games/lutris";
        store = "lutris";
      }
      {
        path = "${config.home.homeDirectory}/Games/Bottles/*";
        store = "otherWine";
      }
      {
        path = "${config.home.homeDirectory}/Games/faugus/*";
        store = "otherWine";
      }
      {
        path = "${config.home.homeDirectory}/Games/Heroic/Prefixes/default/*";
        store = "otherWine";
      }
      {
        path = "${config.home.homeDirectory}/Games/nero/*";
        store = "otherWine";
      }
      {
        path = "${config.home.homeDirectory}/Games/portproton/*";
        store = "otherWine";
      }
      {
        path = "${config.home.homeDirectory}/Games/Steam";
        store = "steam";
      }
    ];
    theme = "dark";
  };
}
