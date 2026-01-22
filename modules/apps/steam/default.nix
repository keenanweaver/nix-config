{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.steam;
in
{
  options.steam = {
    enable = lib.mkEnableOption "Enable Steam in NixOS";
    enableFlatpak = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableNative = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    enableSteamBeta = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    # https://reddit.com/r/linux_gaming/comments/16e1l4h/slow_steam_downloads_try_this/
    fixDownloadSpeed = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = cfg.enableNative;
      package = pkgs.steam.override {
        extraEnv = {
          #MANGOHUD = true;
          #OBS_VKCAPTURE = true;
          PIPEWIRE_NODE = "Game";
          PULSE_SINK = "Game";
          PROTON_ENABLE_WAYLAND = true;
          PROTON_ENABLE_HDR = true;
          PROTON_USE_WOW64 = true;
          PROTON_FSR4_RDNA3_UPGRADE = true;
          PROTON_USE_NTSYNC = true;
        };
        # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
        extraProfile = ''
          unset TZ
        '';
        privateTmp = false; # https://github.com/NixOS/nixpkgs/issues/381923
      };
      extraCompatPackages = with pkgs; [
        proton-cachyos-x86_64-v4
        proton-em
        proton-ge
      ];
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    home-manager.users.${username} =
      { pkgs, config, ... }:
      {
        home = {
          file = {
            steam-beta = {
              enable = cfg.enableSteamBeta;
              text = "publicbeta";
              target = "${config.xdg.dataHome}/Steam/package/beta";
            };
            steam-slow-fix = {
              enable = cfg.fixDownloadSpeed;
              text = ''
                @nClientDownloadEnableHTTP2PlatformLinux 0
                @fDownloadRateImprovementToAddAnotherConnection 1.0
              '';
              target = "${config.xdg.dataHome}/Steam/steam_dev.cfg";
            };
          };
          packages = with pkgs; [
            steamcmd
          ];
        };
        # https://github.com/different-name/steam-config-nix
        programs.steam.config =
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
              svencoop = {
                id = 225840;
                compatTool = "Proton CachyOS x86_64-v4";
                launchOptions = mkDefaultLaunchOpts {
                  disableWayland = true;
                };
              };
            };
          };
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.valvesoftware.Steam" = {
              Context = {
                filesystems = [
                  "${config.home.homeDirectory}/Games"
                  "${config.xdg.dataHome}/applications"
                  "${config.xdg.dataHome}/games"
                  "${config.xdg.dataHome}/Steam"
                ];
              };
              Environment = {
                PULSE_SINK = "Game";
              };
              "Session Bus Policy" = {
                org.freedesktop.Flatpak = "talk";
              };
            };
          };
          packages = [
            "com.valvesoftware.Steam"
          ];
        };
      };
  };
}
