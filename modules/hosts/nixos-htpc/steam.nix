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
                launchOptions.args = [
                  "run"
                  id
                ];

                target = "/run/current-system/sw/bin/flatpak";
              };
              wrapped = pkg: {
                launchOptions.wrappers = [ wrapper ];
                target = lib.getExe pkg;
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
                      { launchOptions.wrappers = [ wrapper ]; }
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
                "Bottles" = bare pkgs.bottles;
                "Dusklight" = wrapped pkgs.dusklight;
                "Fightcade" = flatpak "com.fightcade.Fightcade";
                "Heroic Games Launcher" = bare pkgs.heroic;
                "Moon Child FE" = wrapped pkgs.moon-child-fe;
                "Moonlight" = bare pkgs.moonlight-qt;
                "One Must Fall 2097" = wrapped pkgs.openomf;
                "Pegasus Frontend" = bare pkgs.pegasus-frontend;
                "Ring Racers" = wrapped pkgs.ringracers;
                "SM64CoopDX" = wrapped pkgs.sm64coopdx;
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
