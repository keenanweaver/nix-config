{
  lib,
  config,
  username,
  inputs,
  ...
}:
let
  cfg = config.heroic;
in
{
  options = {
    heroic = {
      enable = lib.mkEnableOption "Enable heroic in home-manager";
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
        home.file = {
          wine-links-proton-cachyos-heroic = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nix-proton-cachyos.packages.x86_64-linux.proton-cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-cachyos";
          };
          wine-links-proton-cachyos-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nix-proton-cachyos.packages.x86_64-linux.proton-cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = ".var/app/com.heroicgameslauncher.hgl/data/heroic/runners/proton-cachyos";
          };
          wine-links-proton-ge-heroic = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-ge-custom";
          };
          wine-links-proton-ge-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = ".var/app/com.heroicgameslauncher.hgl/data/heroic/runners/proton-ge-custom";
          };
        };
        home.packages = lib.mkIf cfg.enableNative [
          (pkgs.heroic.override {
            extraPkgs = pkgs: [
              pkgs.kdePackages.breeze
              inputs.umu.packages.${pkgs.system}.umu
            ];
          })
        ];
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.heroicgameslauncher.hgl" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games"
                  "${config.home.homeDirectory}/Games"
                  "${config.xdg.dataHome}/applications"
                  "${config.xdg.dataHome}/games"
                  "${config.xdg.dataHome}/Steam"
                ];
              };
              Environment = {
                PULSE_SINK = "Game";
              };
            };
          };
          packages = [
            "com.heroicgameslauncher.hgl"
          ];
        };
      };
  };
}
