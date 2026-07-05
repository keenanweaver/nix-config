{
  lib,
  pkgs,
  config,
  inputs,
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
  lowlatency = pkgs.writeShellApplication {
    name = "lowlatency";
    runtimeInputs = with pkgs; [
      scx-loader
    ];
    text = ''
      scxctl switch --sched scx_cake --mode lowlatency
    '';
  };
in
{
  enable = true;
  onSteamRunning = "close";
  defaultCompatTool =
    inputs.nix-gaming-edge.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos;
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
        "Half-Life" = {
          id = 70;
        };
        "Half-Life: Blue Shift" = {
          id = 130;
        };
        "Half-Life: Opposing Force" = {
          id = 50;
        };
        "Helldivers 2" = {
          id = 553850;
          compatTool = config.programs.steam.config.defaultCompatTool;
          launchOptions = {
            args = [
              "+connect_lobby -1" # Skip intro
            ];
            env = {
              WINE_CPU_TOPOLOGY = "8:1,2,3,4,5,6,7,16"; # https://github.com/ValveSoftware/Proton/issues/7486#issuecomment-2683254539
            };
          };
        };
        "Hitman: World of Assassination" = {
          id = 1659040;
          launchOptions = {
            args = [
              "-skip_launcher"
            ];
          };
        };
        "Left 4 Dead 2" = {
          id = 550;
          launchOptions = {
            env = {
              STEAM_COMPAT_RUNTIME_SDL3 = true;
            };
            args = [
              "-novid"
              "-vulkan"
            ];
          };
        };
        "Natural Selection 2" = {
          id = 4920;
          compatTool = config.programs.steam.config.defaultCompatTool;
        };
        "Quake Champions" = {
          id = 611500;
          launchOptions = {
            env = {
              # low-latency-layer
              MANGOHUD_CONFIG = "read_cfg,fps_limit=0"; # https://github.com/Korthos-Software/low_latency_layer/issues/3#issuecomment-4504312483
              LOW_LATENCY_LAYER_REFLEX = true;
              LOW_LATENCY_LAYER_SPOOF_NVIDIA = true;
              PROTON_FORCE_NVAPI = true;
            };
            preHook = ''
              ${lib.getExe lowlatency}
            '';
          };
        };
        "Quake Live" = {
          id = 282440;
          launchOptions = {
            env = {
              # https://steamcommunity.com/sharedfiles/filedetails/?id=3642772367
              # mesa_glthread = "false";
              # MESA_GL_VERSION_OVERRIDE = "3.2";
            };
            preHook = ''
              ${lib.getExe lowlatency}
            '';
          };
        };
        "Reflex Arena" = {
          id = 328070;
          launchOptions = {
            env = {
              MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
              #PROTON_ENABLE_WAYLAND = lib.mkForce false; # Workshop
            };
            preHook = ''
              ${lib.getExe lowlatency}
            '';
          };
        };
        "Ready or Not" = {
          id = 1144200;
          compatTool = config.programs.steam.config.defaultCompatTool;
          launchOptions = {
            env = {
              WINEDLLOVERRIDES = "dxgi=n,b"; # Optiscaler
            };
          };
        };
        "Street Fighter 6" = {
          id = 1364780;
          compatTool = config.programs.steam.config.defaultCompatTool;
        };
        "STRAFTAT" = {
          id = 2386720;
          compatTool = config.programs.steam.config.defaultCompatTool;
        };
        "Sven Co-op" = {
          id = 225840;
          launchOptions = {
            env = {
              PROTON_ENABLE_WAYLAND = lib.mkForce false; # Allows mouse to be OBS captured
            };
          };
        };
        "Teardown" = {
          id = 1167630;
          launchOptions = {
            env = {
              MESA_LOADER_DRIVER_OVERRIDE = lib.mkForce false; # Zink and MangoHud do not mix for some reason
              PROTON_ENABLE_WAYLAND = lib.mkForce false; # Game crashes after splash screens with Wayland
            };
          };
        };
      };
}
