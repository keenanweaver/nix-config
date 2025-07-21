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
          wine-links-kron4ek-lutris = {
            enable = cfg.enableNative;
            source =
              config.lib.file.mkOutOfStoreSymlink
                inputs.nix-gaming.packages.${pkgs.system}.wine-tkg-ntsync;
            target = "${config.xdg.dataHome}/lutris/runners/wine/kron4ek";
          };
          wine-links-kron4ek-lutris-flatpak = {
            enable = cfg.enableFlatpak;
            source =
              config.lib.file.mkOutOfStoreSymlink
                inputs.nix-gaming.packages.${pkgs.system}.wine-tkg-ntsync;
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/wine/kron4ek";
          };
          wine-links-proton-cachyos-lutris = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-cachyos
            }/bin";
            target = "${config.xdg.dataHome}/lutris/runners/proton/proton-cachyos";
          };
          wine-links-proton-cachyos-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-cachyos
            }/bin";
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-cachyos";
          };
          wine-links-proton-ge-lutris = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-bin.steamcompattool}";
            target = "${config.xdg.dataHome}/lutris/runners/proton/proton-ge-bin";
          };
          wine-links-proton-ge-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-bin.steamcompattool}";
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-ge-bin";
          };
        };
        home.packages =
          with pkgs;
          lib.mkIf cfg.enableNative [
            (lutris.override {
              extraPkgs = (
                pkgs: [
                  umu-launcher
                ]
              );
            })
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
