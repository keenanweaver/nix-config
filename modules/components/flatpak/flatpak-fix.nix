{ config, lib, pkgs, ... }:
let
  cfg = config.workarounds.flatpak-fix;
in
{
  options.workarounds.flatpak-fix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.services.flatpak.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bindfs ];
    fileSystems = lib.mapAttrs
      (_: v: v // {
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
        noCheck = true;
      })
      {
        "/usr/share/icons".device = "/run/current-system/sw/share/icons";
        "/usr/share/themes".device = "/run/current-system/sw/share/themes";
        "/usr/share/fonts".device = pkgs.buildEnv
          {
            name = "system-fonts";
            paths = config.fonts.packages;
            pathsToLink = [ "/share/fonts" ];
          } + "/share/fonts";
      };
  };
}
