{ inputs, ... }:
{
  configurations.nixos.nixos-htpc.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      programs.steam.client =
        let
          # Launchers and frontends skip game-wrapper
          bare = pkg: {
            exe = userBin pkg;
            launchOptions = "GAME_WRAPPER=0 %command%";
          };
          flatpak = id: {
            exe = "/run/current-system/sw/bin/flatpak";
            launchOptions = "GAME_WRAPPER=0 %command% run ${id}";
          };
          sysBare = pkg: {
            exe = sysBin pkg;
            launchOptions = "GAME_WRAPPER=0 %command%";
          };
          sysBin = pkg: "/run/current-system/sw/bin/${baseNameOf (lib.getExe pkg)}";
          sysWrapped = pkg: { exe = sysBin pkg; };
          userBin = pkg: "/etc/profiles/per-user/${config.my.user}/bin/${baseNameOf (lib.getExe pkg)}";
          wrapped = pkg: { exe = userBin pkg; };
        in
        {
          clientBeta = "";
          # Street Fighter 6
          games."1364780".compatTool = config.programs.steam.client.defaultCompatTool;
          libraryFolders = [ "/mnt/Games/SteamLibrary" ];
          shortcuts = {
            BanjoRecomp = wrapped pkgs.banjorecomp;
            Bottles = bare pkgs.bottles;
            "Clone Hero" = wrapped pkgs.clonehero;
            Dusklight = wrapped pkgs.dusklight;
            Eden = flatpak "dev.eden_emu.eden";
            Fightcade = flatpak "com.fightcade.Fightcade";
            # https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/issues/4721#issuecomment-5296588981
            "Heroic Games Launcher" = (bare pkgs.heroic) // {
              launchOptions = "GAME_WRAPPER=0 %command% --no-sandbox";
            };
            "Jazz² Resurrection" = wrapped pkgs.jazz2;
            "Moon Child FE" = wrapped pkgs.moon-child-fe;
            Moonlight = sysBare pkgs.moonlight-qt;
            "One Must Fall 2097" = wrapped pkgs.openomf;
            "Pegasus Frontend" = bare pkgs.pegasus-frontend;
            "Prince of Persia" = wrapped pkgs.sdlpop;
            "Ring Racers" = wrapped pkgs.ringracers;
            SM64CoopDX = sysWrapped pkgs.sm64coopdx;
            SM64Ex = wrapped pkgs.sm64ex;
            "Ship of Harkinian" = sysWrapped pkgs.shipwright;
            Slippi = wrapped inputs.slippi-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
            "Sonic 3: Angel Island Revisited" = wrapped pkgs.local.sonic3air;
            "Sonic Robo Blast 2" = wrapped pkgs.srb2;
            Starship = wrapped pkgs.starship-sf64;
            VVVVVV = wrapped pkgs.vvvvvv;
            "Wipeout Rewrite" = wrapped pkgs.wipeout-rewrite;
            YARG = wrapped pkgs.yarg;
            Zelda64Recomp = wrapped pkgs.zelda64recomp;
            shadPS4 = bare pkgs.shadps4-qtlauncher;
          };
        };
    };
}
