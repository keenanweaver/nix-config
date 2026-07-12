{
  configurations.nixos.nixos-htpc.module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home-manager.users.${config.my.user} = {
        programs.steam.config =
          let
            defaultOptions = {
              launchOptions = {
                env = { };
                wrappers = [
                  (lib.getExe pkgs.local.game-wrapper)
                ];
              };
            };
            defaultProton = "Proton-CachyOS Latest";
          in
          {
            apps =
              lib.mapAttrs
                (
                  _: options:
                  lib.mkMerge [
                    options
                    defaultOptions
                  ]
                )
                {
                  "Street Fighter 6" = {
                    compatTool = defaultProton;
                    id = 1364780;
                  };
                };
            defaultCompatTool = lib.mkForce defaultProton;
            nonSteamApps = {
              /*
                "Bottles" = {
                             target = lib.getExe pkgs.bottles;
                           };
              */
              "Dusklight" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.dusklight;
              };
              "Heroic Games Launcher" = {
                target = lib.getExe pkgs.heroic;
              };
              "Moonlight" = {
                target = lib.getExe pkgs.moonlight-qt;
              };
              "One Must Fall 2097" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.openomf;
              };
              "Pegasus Frontend" = {
                target = lib.getExe pkgs.pegasus-frontend;
              };
              "SM64CoopDX" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.sm64coopdx;
              };
              "Ship of Harkinian" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.shipwright-git;
              };
              "Sonic 3: Angel Island Revisited" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.local.sonic3air;
              };
              "Spaghetti Kart" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.spaghetti-kart-git;
              };
              "Starship SF64" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.starship-sf64;
              };
              "Wipeout Rewrite" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.wipeout-rewrite;
              };
              "Zelda64Recomp" = {
                launchOptions.wrappers = [ (lib.getExe pkgs.local.game-wrapper) ];
                target = lib.getExe pkgs.zelda64recomp;
              };
            };
          };
      };
    };
}
