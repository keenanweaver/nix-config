{
  lib,
  config,
  username,
  pkgs,
  inputs,
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
        extraPkgs = (
          pkgs: with pkgs; [
            gamemode
          ]
        );
      };
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda
        inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
        inputs.chaotic.packages.${system}.proton-ge-custom
        steamtinkerlaunch
      ];
      gamescopeSession.enable = true;
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
            steamtinkerlaunch
            (writeShellApplication {
              name = "script-stl-configure";
              runtimeEnv = {
                STL_DEFAULT = "${config.xdg.configHome}/steamtinkerlaunch/default_template.conf";
                STL_GAMECFGS = "${config.xdg.configHome}/steamtinkerlaunch/gamecfgs/id";
                STL_GLOBAL = "${config.xdg.configHome}/steamtinkerlaunch/global.conf";
                STL_GLOBAL_CUSTOM_VARS = "${config.xdg.configHome}/steamtinkerlaunch/gamecfgs/customvars/global-custom-vars.conf";
              };
              runtimeInputs = [
                coreutils
                findutils
                jq
                sd
                steamtinkerlaunch
                xh
              ];
              text = ''
                ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
                steamtinkerlaunch compat add
                sd 'YAD="(.*?)"' 'YAD="${pkgs.yad}/bin/yad"' $STL_GLOBAL
                sd 'STLEDITOR="(.*?)"' 'STLEDITOR="${pkgs.kdePackages.kate}/bin/kate"' $STL_GLOBAL
                sd 'SKIPINTDEPCHECK="(.*?)"' 'SKIPINTDEPCHECK="1"' $STL_GLOBAL
                sd 'USEGAMEMODERUN="(.*?)"' 'USEGAMEMODERUN="0"' $STL_DEFAULT
                sd 'USEOBSCAP="(.*?)"' 'USEOBSCAP="1"' $STL_DEFAULT
                sd 'USEMANGOHUD="(.*?)"' 'USEMANGOHUD="1"' $STL_DEFAULT
                sd 'MAHUDLSYM="(.*?)"' 'MAHUDLSYM="1"' $STL_DEFAULT
                sd 'USERAYTRACING="(.*?)"' 'USERAYTRACING="1"' $STL_DEFAULT
                sd 'USEPROTON="(.*?)"' 'USEPROTON="Proton-GE"' $STL_DEFAULT
                sd 'DXVK_HDR="(.*?)"' 'DXVK_HDR="1"' $STL_DEFAULT
                sd 'GAMESCOPE_ARGS="(.*?)"' 'GAMESCOPE_ARGS="-W 2560 -H 1440 -f -r 360 --hdr-enabled --force-grab-cursor --"' $STL_DEFAULT
                echo 'PULSE_SINK=Game' > "$STL_GLOBAL_CUSTOM_VARS"
                echo 'WINE_CPU_TOPOLOGY=16:0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23' >> "$STL_GLOBAL_CUSTOM_VARS"
              '';
            })
          ];
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
