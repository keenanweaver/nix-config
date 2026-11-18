{ self, config, ... }:
let
  inherit (config.site) nas;
in
{
  flake.modules = {
    homeManager.flatpak-games =
      { config, pkgs, ... }:
      let
        mkBundle =
          {
            appId,
            hash,
            url,
          }:
          {
            inherit appId;
            bundle = "file://${
              pkgs.fetchzip {
                inherit hash url;
                stripRoot = false;
              }
            }/${appId}.flatpak";
            sha256 = hash;
          };
      in
      {
        services.flatpak = {
          overrides = {
            "com.richwhitehouse.BigPEmu".Context.filesystems = [
              "!home"
            ];
            global = {
              Context.filesystems = [
                "xdg-run/discord-ipc-*"
              ];
              Environment.PULSE_SINK = "Game";
            };
            "info.cemu.Cemu".Context.filesystems = [
              "${config.home.homeDirectory}/Games/cemu"
            ];
            "io.github.strikerx3.ymir".Context.filesystems = [
              "!/mnt"
              "${nas.mountRoot}/Games/Rom/CHD/Sega Saturn"
              "${nas.mountRoot}/Games/Mister/Saturn"
            ];
            "net.fsuae.FS-UAE".Context.filesystems = [
              "!home"
            ];
            "net.kuribo64.melonDS".Context.filesystems = [
              "!home"
              "${nas.mountRoot}/Games/Backups/Myrient/No-Intro"
            ];
            "net.pcsx2.PCSX2".Context.filesystems = [
              "host"
              "${nas.mountRoot}/Games/Rom/CHD/Sony Playstation 2"
            ];
            "net.rpcs3.RPCS3".Context.filesystems = [
              "!home"
              "${config.home.homeDirectory}/Games/roms/rpcs3"
            ];
            "org.DolphinEmu.dolphin-emu".Context.filesystems = [
              "${nas.mountRoot}/Games/Rom/CHD/Nintendo GameCube"
            ];
            "org.azahar_emu.Azahar".Context.filesystems = [
              "${config.home.homeDirectory}/Games/3ds"
            ];
            "org.flycast.Flycast".Context.filesystems = [
              "${nas.mountRoot}/Games/Rom/CHD/Sega Dreamcast"
            ];
            "org.mamedev.MAME".Context.filesystems = [
              "${nas.mountRoot}/Games/Rom/Other/MAME"
              "!home"
            ];
          };
          packages = [
            "app.xemu.xemu"
            "com.github.optyfr.JRomManager"
            "com.qzandronum.Q-Zandronum"
            "com.richwhitehouse.BigPEmu"
            "com.supermodel3.Supermodel"
            "dev.ares.ares"
            "info.beyondallreason.bar"
            "info.cemu.Cemu"
            (mkBundle {
              appId = "io.github.hedge_dev.unleashedrecomp";
              hash = "sha256-a8dx9ro515SFHb8l49eDkbXfNuiRGxMuAPaNgwnLHrs=";
              url = "https://github.com/hedge-dev/UnleashedRecomp/releases/download/v1.0.3/UnleashedRecomp-Flatpak.zip";
            })
            (mkBundle {
              appId = "io.github.sonicnext_dev.marathonrecomp";
              hash = "sha256-1nRlVTX/d9JyBFfT7fdBTdpfbSYonESVF+Ft28MGpPc=";
              url = "https://github.com/sonicnext-dev/MarathonRecomp/releases/download/v1.0.0/MarathonRecomp-Flatpak-x86_64.zip";
            })
            "io.github.randovania.Randovania"
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
            "org.mamedev.MAME"
            "org.openfodder.OpenFodder"
            "org.openjkdf2.OpenJKDF2"
            "org.ppsspp.PPSSPP"
            "vet.rsc.OpenRSC.Launcher"
          ];
        };
      };
    nixos.flatpak-games.home-manager.sharedModules = [
      self.modules.homeManager.flatpak-games
    ];
  };
}
