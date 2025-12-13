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
      {
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        home.file = {
          wine-links-kron4ek-lutris-flatpak = {
            enable = cfg.enableFlatpak;
            source = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/wine/kron4ek-nix";
          };
          proton-links-proton-cachyos-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = pkgs.proton-cachyos.steamcompattool;
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-cachyos-nix";
          };
          proton-links-proton-em-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = pkgs.proton-em.steamcompattool;
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-em-nix";
          };
          proton-links-proton-ge-flatpak-lutris = {
            enable = cfg.enableFlatpak;
            source = pkgs.proton-ge.steamcompattool;
            target = ".var/app/net.lutris.Lutris/data/lutris/runners/proton/proton-ge-nix";
          };
        };
        programs.lutris = lib.mkIf cfg.enableNative {
          enable = true;
          extraPackages = with pkgs; [
            gamemode
            gamescope
            mangohud
            umu-launcher
            winetricks
          ];
          protonPackages = with pkgs; [
            #proton-cachyos
            proton-em
            proton-ge
          ];
          steamPackage = osConfig.programs.steam.package;
          winePackages = with pkgs; [
            inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-tkg
          ];
        };
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
