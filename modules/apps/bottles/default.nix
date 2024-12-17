{
  lib,
  config,
  username,
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
          wine-links-protonge-bottles = {
            enable = cfg.enableNative;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = "${config.home.homeDirectory}/bottles/runners/proton-ge-custom";
          };
          wine-links-protonge-bottles-flatpak = {
            enable = cfg.enableFlatpak;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = ".var/app/com.usebottles.bottles/data/bottles/runners/proton-ge-custom";
          };
        };
        home.packages = lib.mkIf cfg.enableNative [ pkgs.bottles ];
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.usebottles.bottles" = {
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
            "com.usebottles.bottles"
          ];
        };
      };
  };
}
