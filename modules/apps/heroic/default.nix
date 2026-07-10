{
  lib,
  config,
  username,
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
      {
        config,
        pkgs,
        ...
      }:
      {
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
