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
        default = true;
      };
      enableNative = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home.file = {
          wine-links-kron4ek-bottles = {
            enable = false;
            source = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
            target = "${config.xdg.dataHome}/bottles/runners/kron4ek";
          };
          wine-links-kron4ek-bottles-flatpak = {
            enable = false;
            source = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
            target = ".var/app/com.usebottles.bottles/data/bottles/runners/kron4ek";
          };
          wine-links-proton-cachyos-bottles = {
            enable = cfg.enableNative;
            source = "${inputs.nur-bandithedoge.legacyPackages.${pkgs.system}.proton.cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = "${config.xdg.dataHome}/bottles/runners/proton-cachyos";
          };
          wine-links-proton-cachyos-flatpak-bottles = {
            enable = cfg.enableFlatpak;
            source = "${inputs.nur-bandithedoge.legacyPackages.${pkgs.system}.proton.cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-cachyos";
          };
          wine-links-protonge-bottles = {
            enable = cfg.enableNative;
            source = "${
              inputs.nur-bandithedoge.legacyPackages.${pkgs.system}.proton.ge
            }/share/steam/compatibilitytools.d/proton-ge";
            target = "${config.xdg.dataHome}/bottles/runners/proton-ge-bin";
          };
          wine-links-protonge-flatpak-bottles = {
            enable = cfg.enableFlatpak;
            source = "${
              inputs.nur-bandithedoge.legacyPackages.${pkgs.system}.proton.ge
            }/share/steam/compatibilitytools.d/proton-ge";
            target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-ge-bin";
          };
        };
        home.packages = lib.mkIf cfg.enableNative [
          (pkgs.bottles.override {
            removeWarningPopup = true;
          })
        ];
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
                PROTON_ENABLE_WAYLAND = "1";
                PROTON_ENABLE_HDR = "1";
                PROTON_FSR4_RDNA3_UPGRADE = "1";
                PROTON_USE_NTSYNC = "1";
                PROTON_USE_WOW64 = "1";
                WINE_CPU_TOPOLOGY = "16:0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23";
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
              exec = "env PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 PROTON_USE_NTSYNC=1 PROTON_USE_WOW64=1 PIPEWIRE_NODE=Game PULSE_SINK=Game bottles %u";
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
