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
    programs.java.enable = true;
    programs.steam = {
      enable = cfg.enableNative;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda
        #proton-ge-bin
        proton-ge-custom
      ];
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraBwrapArgs = [ "--unsetenv TZ" ]; # https://github.com/NixOS/nixpkgs/issues/338266#issuecomment-2419568331
        extraLibraries =
          pkgs: with pkgs; [
            alsa-lib
            libGL
            SDL
            SDL_image
            SDL_mixer
            SDL_ttf
            SDL2
            SDL2_image
            SDL2_mixer
            SDL2_ttf
            xorg.libX11
          ];
      };
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
            # SteamTinkerLaunch tools
            steamtinkerlaunch
            gawk
            procps
            unixtools.xxd
            xdotool
            xorg.xprop
            xorg.xrandr
            xorg.xwininfo
            yad
          ];
        };
      };
  };
}
