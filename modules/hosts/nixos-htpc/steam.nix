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
              bare = pkg: { target = userBin pkg; };
              defaultProton = "Proton-CachyOS Latest";
              flatpak = id: {
                args = [
                  "run"
                  id
                ];
                target = "/run/current-system/sw/bin/flatpak";
              };
              sysBare = pkg: { target = sysBin pkg; };
              sysBin = pkg: "/run/current-system/sw/bin/${baseNameOf (lib.getExe pkg)}";
              sysWrapped = pkg: {
                target = sysBin pkg;
                wrappers = [ wrapper ];
              };
              userBin = pkg: "/etc/profiles/per-user/${config.my.user}/bin/${baseNameOf (lib.getExe pkg)}";
              wrapped = pkg: {
                target = userBin pkg;
                wrappers = [ wrapper ];
              };
              wrapper = "/etc/profiles/per-user/${config.my.user}/bin/${baseNameOf (lib.getExe pkgs.local.game-wrapper)}";
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
                    "1364780" = {
                      compatTool = defaultProton;
                      name = "Street Fighter 6";
                    };
                  };
              defaultCompatTool = lib.mkForce defaultProton;
              nonSteamApps = lib.mapAttrs (_: opts: { startIn = null; } // opts) {
                #"BanjoRecomp" = wrapped pkgs.banjorecomp;
                "Bottles" = bare pkgs.bottles;
                "Clone Hero" = wrapped pkgs.clonehero;
                #"Dusklight" = wrapped pkgs.dusklight;
                "Fightcade" = flatpak "com.fightcade.Fightcade";
                #"Ghostship" = sysWrapped pkgs.ghostship;

                # https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/issues/4721#issuecomment-5296588981
                "Heroic Games Launcher" = (bare pkgs.heroic) // {
                  args = [
                    "--no-sandbox"
                  ];
                };
                "Jazz² Resurrection" = wrapped pkgs.jazz2;
                "Moon Child FE" = wrapped pkgs.moon-child-fe;
                "Moonlight" = sysBare pkgs.moonlight-qt;
                "One Must Fall 2097" = wrapped pkgs.openomf;
                "Pegasus Frontend" = bare pkgs.pegasus-frontend;
                "Prince of Persia" = wrapped pkgs.sdlpop;
                "Ring Racers" = wrapped pkgs.ringracers;
                "SM64CoopDX" = sysWrapped pkgs.sm64coopdx;
                "SM64Ex" = wrapped pkgs.sm64ex;
                "Ship of Harkinian" = sysWrapped pkgs.shipwright-git;
                "Slippi" = wrapped inputs.slippi.packages.${pkgs.stdenv.hostPlatform.system}.default;
                "Sonic 3: Angel Island Revisited" = wrapped pkgs.local.sonic3air;
                "Sonic Robo Blast 2" = wrapped pkgs.srb2;
                #"Spaghetti Kart" = sysWrapped pkgs.spaghetti-kart-git;
                #"Starship SF64" = sysWrapped pkgs.starship-sf64;
                "Wipeout Rewrite" = wrapped pkgs.wipeout-rewrite;
                "YARG" = wrapped pkgs.yarg;
                "Zelda64Recomp" = wrapped pkgs.zelda64recomp;
                "shadPS4" = bare pkgs.shadps4-qtlauncher;
              };
            };
        };
    };
}
