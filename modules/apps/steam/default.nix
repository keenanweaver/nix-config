{ lib, config, username, pkgs, ... }:
{
  options = {
    steam = {
      enable = lib.mkEnableOption "Enable Steam in NixOS";
    };
  };
  config = lib.mkIf config.steam.enable {
    hardware = {
      steam-hardware.enable = true;
    };

    programs = {
      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [
          proton-ge-custom # Chaotic package
        ];
        gamescopeSession.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
          };
          extraLibraries = pkgs: with pkgs; [
            openssl
            #openssl_1_1 # Devil Daggers
            wqy_zenhei
          ];
          extraPkgs = pkgs: with pkgs; [
            ### Gamescope
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            ###
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
          ];
        };
        remotePlay.openFirewall = true;
      };
    };

    home-manager.users.${username} = { pkgs, ... }: {
      home.packages = with pkgs; [
        protontricks
      ];
    };
  };
}
