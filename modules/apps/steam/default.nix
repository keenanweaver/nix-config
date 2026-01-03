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
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = cfg.enableNative;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
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
        programs.steam.config = {
          enable = true;
          closeSteam = true;
          apps = {
            helldivers2 = {
              id = 553850;
              launchOptions = {
                env = {
                  WINE_CPU_TOPOLOGY = "8:1,2,3,4,5,6,7,8"; # https://github.com/ValveSoftware/Proton/issues/7486#issuecomment-2683254539
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
            svencoop = {
              id = 225840;
              compatTool = "Proton EM";
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
