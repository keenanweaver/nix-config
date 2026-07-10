{
  lib,
  config,
  username,
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
        inputs,
        pkgs,
        osConfig,
        ...
      }:
      {
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
            inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.proton-cachyos
            proton-dw
            proton-em
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
