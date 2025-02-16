{
  lib,
  config,
  username,
  inputs,
  ...
}:
let
  cfg = config.lutris;
in
{
  options = {
    lutris = {
      enable = lib.mkEnableOption "Enable lutris in home-manager";
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
          wine-links-proton-cachyos-lutris = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = "${config.xdg.dataHome}/lutris/runners/proton/proton-cachyos";
          };
          wine-links-proton-cachyos-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos}/share/steam/compatibilitytools.d/proton-cachyos";
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-cachyos";
          };
          wine-links-proton-ge-lutris = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom}/bin";
            target = "${config.xdg.dataHome}/lutris/runners/proton/proton-ge-custom";
          };
          wine-links-proton-ge-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom}/bin";
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-ge-custom";
          };
        };
        home.packages = lib.mkIf cfg.enableNative [
          pkgs.lutris
        ];
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "net.lutris.Lutris" = {
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
              "Session Bus Policy" = {
                "org.freedesktop.Flatpak" = "talk";
              };
            };
          };
          packages = [
            "net.lutris.Lutris"
          ];
        };
      };
  };
}
