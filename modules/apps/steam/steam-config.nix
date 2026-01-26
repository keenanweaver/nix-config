{
  lib,
  pkgs,
  config,
}:
let
  mkDefaultLaunchOpts =
    extraOpts:
    lib.recursiveUpdate
      {
        wrappers = [
          (lib.getExe pkgs.gamemode)
          (lib.getExe' pkgs.obs-studio-plugins.obs-vkcapture "obs-gamecapture")
          (lib.getExe pkgs.mangohud)
        ];
      }
      (
        removeAttrs extraOpts [
          "enableZink"
          "disableWayland"
        ]
        // lib.optionalAttrs (extraOpts.enableZink or false) {
          env.MESA_LOADER_DRIVER_OVERRIDE = "zink";
        }
        // lib.optionalAttrs (extraOpts.disableWayland or false) {
          env.PROTON_ENABLE_WAYLAND = false;
        }
      );
in
{
  enable = true;
  closeSteam = true;
  defaultCompatTool = "Proton CachyOS x86_64-v4";
  apps = {
    hl = {
      id = 70;
      launchOptions = mkDefaultLaunchOpts {
        enableZink = true;
      };
    };
    hlbs = {
      id = 130;
      launchOptions = mkDefaultLaunchOpts {
        enableZink = true;
      };
    };
    hlof = {
      id = 50;
      launchOptions = mkDefaultLaunchOpts {
        enableZink = true;
      };
    };
    helldivers2 = {
      id = 553850;
      launchOptions = mkDefaultLaunchOpts {
        env = {
          WINE_CPU_TOPOLOGY = "8:1,2,3,4,5,6,7,16"; # https://github.com/ValveSoftware/Proton/issues/7486#issuecomment-2683254539
        };
      };
    };
    hitmanwoa = {
      id = 1659040;
      launchOptions = mkDefaultLaunchOpts {
        args = [
          "-skip_launcher"
        ];
      };
    };
    quakelive = {
      id = 282440;
      launchOptions = mkDefaultLaunchOpts {
        enableZink = true;
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
      launchOptions = mkDefaultLaunchOpts { };
    };
    svencoop = {
      id = 225840;
      compatTool = config.programs.steam.config.defaultCompatTool;
      launchOptions = mkDefaultLaunchOpts {
        disableWayland = true;
      };
    };
  };
}
