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
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          PROTON_ENABLE_WAYLAND = true;
          PROTON_ENABLE_HDR = true;
          PULSE_SINK = "Game";
        };
        # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
        extraProfile = ''
          unset TZ
        '';
      };
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda
        inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
        proton-ge-bin
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
