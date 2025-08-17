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
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-cachyos
            }/bin";
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-cachyos";
          };
          wine-links-proton-cachyos-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-cachyos
            }/bin";
            target = ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-cachyos";
          };
          wine-links-proton-ge-heroic = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-bin.steamcompattool}";
            target = "${config.xdg.configHome}/heroic/tools/proton/proton-ge-bin";
          };
          wine-links-proton-ge-flatpak-heroic = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-bin.steamcompattool}";
            target = ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-ge-bin";
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
                  "${config.xdg.dataHome}/games"
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
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
          ];
        };
      };
  };
}
