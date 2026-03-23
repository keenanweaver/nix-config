{
  lib,
  pkgs,
  config,
}:
let
  defaultOptions = {
    launchOptions = {
      env = { };
      wrappers = [
        (lib.getExe pkgs.game-wrapper)
      ];
    };
  };
in
{
  enable = true;
  closeSteam = true;
  defaultCompatTool = "Proton CachyOS x86_64-v4";
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
        hl = {
          id = 70;
        };
        hlbs = {
          id = 130;
        };
        hlof = {
          id = 50;
        };
        helldivers2 = {
          id = 553850;
          launchOptions = {
            args = [
              "+connect_lobby -1" # Skip intro
            ];
            env = {
              WINE_CPU_TOPOLOGY = "8:1,2,3,4,5,6,7,16"; # https://github.com/ValveSoftware/Proton/issues/7486#issuecomment-2683254539
            };
          };
        };
        hitmanwoa = {
          id = 1659040;
          launchOptions = {
            args = [
              "-skip_launcher"
            ];
          };
        };
        ns2 = {
          id = 4920;
          compatTool = config.programs.steam.config.defaultCompatTool;
        };
        quakelive = {
          id = 282440;
          launchOptions = {
            env = {
              # https://steamcommunity.com/sharedfiles/filedetails/?id=3642772367
              # mesa_glthread = "false";
              # MESA_GL_VERSION_OVERRIDE = "3.2";
            };
          };
        };
        sf6 = {
          id = 1364780;
          compatTool = config.programs.steam.config.defaultCompatTool;
        };
        svencoop = {
          id = 225840;
          launchOptions = {
            env = {
              PROTON_ENABLE_WAYLAND = lib.mkForce false; # Allows mouse to be OBS captured
            };
          };
        };
        teardown = {
          id = 1167630;
          launchOptions = {
            env = {
              MESA_LOADER_DRIVER_OVERRIDE = lib.mkForce null; # Zink and MangoHud do not mix for some reason
              PROTON_ENABLE_WAYLAND = lib.mkForce false; # Game crashes after splash screens with Wayland
            };
          };
        };
      };
}
