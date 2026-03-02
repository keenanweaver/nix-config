{
  lib,
  pkgs,
  config,
}:
let
  defaultOptions = {
    launchOptions = {
      env = {
        PIPEWIRE_NODE = "Game";
        PULSE_SINK = "Game";
        PROTON_ENABLE_HDR = true;
        PROTON_ENABLE_WAYLAND = true;
        PROTON_FSR4_RDNA3_UPGRADE = true;
        PROTON_USE_NTSYNC = true;
        PROTON_USE_WOW64 = true;
        WINEDLLOVERRIDES = "dinput8,dxgi,dsound,ddraw=n,b";
      };
      wrappers = [
        (lib.getExe pkgs.gamemode)
        (lib.getExe' pkgs.obs-studio-plugins.obs-vkcapture "obs-gamecapture")
        (lib.getExe pkgs.mangohud)
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
          launchOptions = {
            env = {
              MESA_LOADER_DRIVER_OVERRIDE = "zink";
            };
          };
        };
        hlbs = {
          id = 130;
          launchOptions = {
            env = {
              MESA_LOADER_DRIVER_OVERRIDE = "zink";
            };
          };
        };
        hlof = {
          id = 50;
          launchOptions = {
            env = {
              MESA_LOADER_DRIVER_OVERRIDE = "zink";
            };
          };
        };
        helldivers2 = {
          id = 553850;
          launchOptions = {
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
              MESA_LOADER_DRIVER_OVERRIDE = "zink";
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
              MESA_LOADER_DRIVER_OVERRIDE = "zink";
              PROTON_ENABLE_WAYLAND = lib.mkForce false;
            };
          };
        };
      };
}
