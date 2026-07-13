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
              exec = "env PIPEWIRE_NODE=Game PULSE_SINK=Game bottles %u";
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
