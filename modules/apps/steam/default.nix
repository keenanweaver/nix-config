{
  lib,
  config,
  username,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.steam;
in
{
  options.steam = {
    enable = lib.mkEnableOption "Enable Steam in NixOS";
    # https://reddit.com/r/linux_gaming/comments/16e1l4h/slow_steam_downloads_try_this/
    fixDownloadSpeed = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf config.steam.enable {
    programs.java.enable = true;
    programs.steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda # Chaotic package
        proton-ge-custom # Chaotic package
      ];
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          #ENABLE_VKBASALT = "1";
        };
        extraLibraries =
          pkgs: with pkgs; [
            openssl
            #openssl_1_1 # Devil Daggers
            wqy_zenhei
          ];
        extraPkgs =
          pkgs: with pkgs; [
            inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
            ### Gamescope
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            /*
              corefonts
              curl
              harfbuzz
              imagemagick
              gnome.zenity
              libgdiplus
              libthai
              libxcrypt-legacy
              ncurses6 # CK III
              pango
              vkbasalt
              xdotool
            */
          ];
        withJava = config.programs.java.enable;
      };
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    home-manager.users.${username} =
      { pkgs, config, ... }:
      {
        home = {
          file = {
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
            # SteamTinkerLaunch & tools
            (steamtinkerlaunch.overrideAttrs (o: {
              src = inputs.steamtinkerlaunch-master;
            }))
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
