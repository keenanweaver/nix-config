{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  p = with pkgs; {
    games = [
      ## Doom
      cherry-doom
      chocolate-doom
      crispy-doom
      darkradiant
      dhewm3
      doom64ex-plus
      doomrunner
      doomseeker
      dsda-doom
      gzdoom
      nugget-doom
      # odamex
      prboom-plus
      rbdoom-3-bfg
      # slade
      woof-doom
      zandronum
      ## Fallout
      fallout-ce
      fallout2-ce
      ## Freespace
      descent3
      dxx-rebirth
      knossosnet
      ## HOMM
      fheroes2
      vcmi
      ## Marathon
      alephone-marathon
      alephone-durandal
      alephone-infinity
      ## Morrowind
      inputs.openmw-nix.packages.${pkgs.system}.openmw-dev
      #openmw
      ## Quake
      ironwail
      q2pro
      quake-injector
      # trenchbroom
      ## Arma
      arma3-unix-launcher
      # (arma3-unix-launcher.override { buildDayZLauncher = true; })
      ## Duke
      eduke32
      raze
      rigel-engine
      ## Wolf
      bstone
      ecwolf
      etlegacy
      iortcw
      ## Other
      # _2ship2harkinian
      abuse
      am2rlauncher
      arx-libertatis # Arx Fatalis
      augustus # Caesar 3
      clonehero # Guitar Hero
      corsix-th # Theme Hospital
      devilutionx # Diablo
      exult # Ultima VII
      # ja2-stracciatella
      jazz2
      katawa-shoujo-re-engineered
      nur.repos.Rhys-T.lix-game # Lemmings clone
      openjk # Jedi Academy
      openloco
      # opennox
      openomf
      openrct2
      (openttd.overrideAttrs {
        postPatch = ''
          substituteInPlace src/music/fluidsynth.cpp \
            --replace-fail "/usr/share/soundfonts/default.sf2" \
                           "${pkgs.soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2"
        '';
      })
      opentyrian
      (openxcom.overrideAttrs {
        pname = "openxcom-extended";
        version = "8.2.7";
        src = fetchFromGitHub {
          owner = "MeridianOXC";
          repo = "OpenXcom";
          rev = "2c68684ee55e6305ac945771a23ae3ae8f6b3633";
          hash = "sha256-IjUfmdrBPe1nvV2beoExs8ALlJTF3J2QXByH1Qz9Kf8=";
        };
      })
      openxray # STALKER
      perfect_dark
      prismlauncher # MineCraft
      relive # Oddworld
      ringracers
      runelite # RuneScape
      shipwright
      sm64ex
      space-station-14-launcher
      #inputs.nix-citizen.packages.${system}.star-citizen
      starship-sf64
      srb2
      theforceengine # Dark Forces / Outlaws
      urbanterror
      wipeout-rewrite
      xivlauncher # FFXIV
      vvvvvv
      zelda64recomp
    ];
    tools = [
      ## Emulators
      _86Box-with-roms
      # archipelago
      ares
      azahar
      bigpemu
      # bizhawk
      cemu
      dolphin-emu
      duckstation
      flycast
      fsuae-launcher
      hypseus-singe
      mame
      mednafen
      mednaffe
      melonDS
      mesen
      nuked-sc55
      pcsx2
      pegasus-frontend
      ppsspp
      (retroarch.withCores (
        cores: with cores; [
          beetle-saturn
          blastem
          mgba
        ]
      ))
      rpcs3
      ryubing
      scummvm
      shadps4
      supermodel
      #nur.repos.novel2430.vita3k
      xemu
      ## Input
      ## Launchers & utils
      cartridges
      itch
      ## Modding
      #hedgemodmanager
      limo
      nexusmods-app-unfree
      #owmods-gui
      r2modman
      ## Other
      adwsteamgtk
      #chiaki-ng
      faugus-launcher
      flips
      gswatcher
      igir
      innoextract
      lgogdownloader
      moondeck-buddy # Pending https://github.com/NixOS/nixpkgs/pull/375287
      parsec-bin
      xlink-kai
      xvidcore
      ## Wine
      #inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
      umu-launcher
      winetricks
      ## One-and-dones
      /*
        inputs.aaru.packages.${pkgs.system}.default
           inputs.nix-game-preservation.packages.${pkgs.system}.dic-git-full
           glxinfo
           jpsxdec
           mame.tools
           mmv
           inputs.nix-game-preservation.packages.${pkgs.system}.ndecrypt-git
           nsz
           inputs.nix-game-preservation.packages.${pkgs.system}.sabretools-git
           inputs.nix-game-preservation.packages.${pkgs.system}.unshieldsharp-git
           ps3-disc-dumper
           #(python3.withPackages (p: with p; [ lnkparse3 ]))
           inputs.nix-game-preservation.packages.${pkgs.system}.redumper-git
           renderdoc
           vgmplay-libvgm
           vgmstream
           vgmtools
           vgmtrans
           vulkan-tools
      */
    ];
  };
in
{
  home-manager.users.${username} = {
    home.packages = [ (lib.flatten (lib.attrValues p)) ];
    services.flatpak = {
      overrides = {
        global = {
          Environment = {
            FLATPAK_GL_DRIVERS = "mesa-git";
          };
        };
        "com.fightcade.Fightcade" = {
          Environment = {
            PULSE_SINK = "Game";
          };
        };
        "dev.opengoal.OpenGOAL" = {
          Context = {
            filesystems = [ "${config.home.homeDirectory}/Games/opengoal" ];
          };
          Environment = {
            PULSE_SINK = "Game";
          };
        };
        "io.github.noxworld_dev.OpenNox" = {
          Context = {
            filesystems = [
              "!home"
              "${config.home.homeDirectory}/Games/nox"
            ];
          };
          Environment = {
            PULSE_SINK = "Game";
          };
        };
        "net.sourceforge.uqm_mods.UQM-MegaMod" = {
          Environment = {
            PULSE_SINK = "Game";
          };
        };
        "org.easyrpg.player" = {
          Context = {
            filesystems = [
              "${config.home.homeDirectory}/Music/soundfonts:ro"
              "${config.home.homeDirectory}/Games/games/rpg-maker"
              "!host"
            ];
            shared = "network"; # obs-gamecapture
          };
          Environment = {
            PULSE_SINK = "Game";
            RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2000";
            RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2003";
          };
        };
        "org.openjkdf2.OpenJKDF2" = {
          Environment = {
            PULSE_SINK = "Game";
          };
        };
        "org.sonic3air.Sonic3AIR" = {
          Environment = {
            PULSE_SINK = "Game";
          };
        };
      };
      packages = [
        "com.fightcade.Fightcade"
        "com.fightcade.Fightcade.Wine"
        {
          appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/24.08";
          origin = "flathub-beta";
        }
        {
          appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/24.08";
          origin = "flathub-beta";
        }
        "com.github.optyfr.JRomManager"
        "com.qzandronum.Q-Zandronum"
        "dev.opengoal.OpenGOAL"
        "io.github.hedge_dev.hedgemodmanager"
        "io.github.noxworld_dev.OpenNox"
        "io.github.randovania.Randovania"
        "io.github.santiagocezar.maniatic-launcher"
        "io.itch.tx00100xt.SeriousSamClassic-VK"
        "net.nmlgc.rec98.sh01"
        "net.sourceforge.uqm_mods.UQM-MegaMod"
        "org.easyrpg.player"
        "org.openfodder.OpenFodder"
        "org.openjkdf2.OpenJKDF2"
        "org.sonic3air.Sonic3AIR"
        "vet.rsc.OpenRSC.Launcher"
      ];
    };
    xdg = {
      autostart.entries = with pkgs; [
        "${moondeck-buddy}/share/applications/MoonDeckBuddy.desktop"
        "${nuked-sc55}/share/applications/Nuked-SC55_silent.desktop"
      ];
      desktopEntries = {
        _86box = {
          name = "86Box (Win98SE)";
          exec = "86Box";
          icon = "net.86box.86Box";
          categories = [
            "Game"
            "Emulator"
          ];
          settings = {
            Path = "${config.home.homeDirectory}/Games/games/86box/win98se";
          };
        };
        gog-galaxy =
          let
            icon = pkgs.fetchurl {
              url = "https://docs.gog.com/_assets/galaxy_icon_rgb.svg";
              hash = "sha256-SpaFaSK05Uq534qPYV7s7/vzexZmMnpJiVtOsbCtjvg=";
            };
          in
          {
            name = "GOG Galaxy";
            comment = "Launch GOG Galaxy using Bottles.";
            exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p \"GOG Galaxy\" -b \"GOG Galaxy\" -- %u";
            icon = "${icon}";
            categories = [ "Game" ];
            noDisplay = false;
            startupNotify = true;
            settings = {
              StartupWMClass = "GOG Galaxy";
            };
          };
        itch = {
          name = "itch";
          comment = "Install and play itch.io games easily";
          exec = "PULSE_SINK=Game obs-gamecapture mangohud itch";
          icon = "itch";
          categories = [ "Game" ];
        };
        quake-injector = {
          name = "Quake Injector";
          exec = "quake-injector";
          icon = "quake-injector";
          categories = [ "Game" ];
          settings = {
            Path = "${config.home.homeDirectory}/Games/quake/quake-1/injector";
          };
        };
      };
    };
  };
}
