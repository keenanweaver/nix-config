{
  lib,
  config,
  username,
  inputs,
  ...
}:
let
  cfg = config.bottles;
in
{
  options = {
    bottles = {
      enable = lib.mkEnableOption "Enable bottles in home-manager";
      enableFlatpak = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      enableNative = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home = {
          file = {
            proton-links-kron4ek-bottles = {
              enable = false;
              source = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
              target = "${config.xdg.dataHome}/bottles/runners/kron4ek-nix";
            };
            proton-links-kron4ek-bottles-flatpak = {
              enable = false;
              source = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
              target = ".var/app/com.usebottles.bottles/data/bottles/runners/kron4ek-nix";
            };
            proton-links-proton-cachyos-bottles = {
              enable = cfg.enableNative;
              source = pkgs.proton-cachyos-x86_64_v4.steamcompattool;
              target = "${config.xdg.dataHome}/bottles/runners/proton-cachyos-nix";
            };
            proton-links-proton-cachyos-flatpak-bottles = {
              enable = cfg.enableFlatpak;
              source = pkgs.proton-cachyos-x86_64_v4.steamcompattool;
              target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-cachyos-nix";
            };
            proton-links-proton-em-bottles = {
              enable = cfg.enableNative;
              source = pkgs.proton-em.steamcompattool;
              target = "${config.xdg.dataHome}/bottles/runners/proton-em-nix";
            };
            proton-links-proton-em-flatpak-bottles = {
              enable = cfg.enableFlatpak;
              source = pkgs.proton-em.steamcompattool;
              target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-em-nix";
            };
            proton-links-proton-ge-bottles = {
              enable = cfg.enableNative;
              source = pkgs.proton-ge.steamcompattool;
              target = "${config.xdg.dataHome}/bottles/runners/proton-ge-nix";
            };
            proton-links-proton-ge-flatpak-bottles = {
              enable = cfg.enableFlatpak;
              source = pkgs.proton-ge.steamcompattool;
              target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-ge-nix";
            };
          };
          packages = lib.mkIf cfg.enableNative [
            (pkgs.bottles.override {
              removeWarningPopup = true;
            })
          ];
        };
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.usebottles.bottles" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games"
                  "/mnt/crusader/Media/Audio/Music"
                  "${config.home.homeDirectory}/Downloads"
                  "${config.home.homeDirectory}/Games"
                  "${config.xdg.dataHome}/applications"
                  "${config.xdg.dataHome}/games"
                  "${config.xdg.dataHome}/Steam"
                ];
              };
              Environment = {
                PROTON_ENABLE_HDR = "1";
                PROTON_FSR4_RDNA3_UPGRADE = "1";
                PROTON_USE_NTSYNC = "1";
                PROTON_USE_WOW64 = "1";
              };
              "Session Bus Policy" = {
                "org.freedesktop.Flatpak" = "talk";
              };
            };
          };
          packages = [
            "com.usebottles.bottles"
          ];
        };
        xdg = {
          desktopEntries = {
            "bottles" = lib.mkIf cfg.enableNative {
              name = "Bottles";
              comment = "Run Windows software";
              exec = "env PROTON_ENABLE_HDR=1 PROTON_USE_NTSYNC=1 PROTON_USE_WOW64=1 PIPEWIRE_NODE=Game PULSE_SINK=Game bottles %u";
              terminal = false;
              icon = "com.usebottles.bottles";
              type = "Application";
              startupNotify = true;
              categories = [
                "Utility"
                "Game"
              ];
            };
          };
        };
      };
  };
}
