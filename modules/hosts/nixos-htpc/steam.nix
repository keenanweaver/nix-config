{
  configurations.nixos.nixos-htpc.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home-manager.users.${config.my.user} =
        { inputs, ... }:
        {
          programs.steam.config =
            let
              bare = pkg: { target = lib.getExe pkg; };
              defaultProton = "Proton-CachyOS Latest";
              flatpak = id: {
                args = [
                  "run"
                  id
                ];

                target = "/run/current-system/sw/bin/flatpak";
              };
              wrapped = pkg: {
                target = lib.getExe pkg;
                wrappers = [ wrapper ];
              };
              wrapper = lib.getExe pkgs.local.game-wrapper;
            in
            {
              apps =
                lib.mapAttrs
                  (
                    _: opts:
                    lib.mkMerge [
                      opts
                      { wrappers = [ wrapper ]; }
                    ]
                  )
                  {
                    "Street Fighter 6" = {
                      compatTool = defaultProton;
                      id = 1364780;
                    };
                  };

              defaultCompatTool = lib.mkForce defaultProton;

              nonSteamApps = lib.mapAttrs (_: opts: { startIn = null; } // opts) {
                #"BanjoRecomp" = wrapped pkgs.banjorecomp;
                "Bottles" = bare pkgs.bottles;
                "Clone Hero" = wrapped pkgs.clonehero;
                "Dusklight" = wrapped pkgs.dusklight;
                "Fightcade" = flatpak "com.fightcade.Fightcade";
                "Ghostship" = wrapped pkgs.ghostship;
                "Heroic Games Launcher" = bare pkgs.heroic;
                "Jazz² Resurrection" = wrapped pkgs.jazz2;
                "Moon Child FE" = wrapped pkgs.moon-child-fe;
                "Moonlight" = bare pkgs.moonlight-qt;
                "One Must Fall 2097" = wrapped pkgs.openomf;
                "Pegasus Frontend" = bare pkgs.pegasus-frontend;
                "Prince of Persia" = wrapped pkgs.sdlpop;
                "Ring Racers" = wrapped pkgs.ringracers;
                "SM64CoopDX" = wrapped pkgs.sm64coopdx;
                "SM64Ex" = wrapped pkgs.sm64ex;
                "Ship of Harkinian" = wrapped pkgs.shipwright-git;
                "Slippi" = wrapped inputs.slippi.packages.${pkgs.stdenv.hostPlatform.system}.default;
                "Sonic 3: Angel Island Revisited" = wrapped pkgs.local.sonic3air;
                "Sonic Robo Blast 2" = wrapped pkgs.srb2;
                "Spaghetti Kart" = wrapped pkgs.spaghetti-kart-git;
                "Starship SF64" = wrapped pkgs.starship-sf64;
                "Wipeout Rewrite" = wrapped pkgs.wipeout-rewrite;
                "Zelda64Recomp" = wrapped pkgs.zelda64recomp;
                "shadPS4" = bare pkgs.shadps4-qtlauncher;
              };
            };
        };
    };
}
