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
          proton-links-proton-cachyos-heroic = {
            enable = cfg.enableNative;
            source = "${pkgs.proton-cachyos-x86_64_v4}/share/steam/compatibilitytools.d/proton-cachyos-x86_64_v4";
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-cachyos-nix";
          };
          proton-links-proton-cachyos-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = "${pkgs.proton-cachyos-x86_64_v4}/share/steam/compatibilitytools.d/proton-cachyos-x86_64_v4";
            target = ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-cachyos-nix";
          };
          proton-links-proton-ge-heroic = {
            enable = cfg.enableNative;
            source = pkgs.proton-ge.steamcompattool;
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-ge-nix";
          };
          proton-links-proton-ge-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = pkgs.proton-ge.steamcompattool;
            target = ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-ge-nix";
          };
          proton-links-proton-em-heroic = {
            enable = cfg.enableNative;
            source = pkgs.proton-em.steamcompattool;
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-em-nix";
          };
          proton-links-proton-em-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = pkgs.proton-em.steamcompattool;
            target = ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-em-nix";
          };
        };
        home.packages = with pkgs; lib.mkIf cfg.enableNative [ heroic ];
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.heroicgameslauncher.hgl" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games"
                  "${config.home.homeDirectory}/Games"
                  "${config.xdg.dataHome}/applications"
                  "${config.xdg.dataHome}/Steam"
                ];
              };
              "Session Bus Policy" = {
                "org.freedesktop.Flatpak" = "talk";
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
