{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mounts;
in
{
  options = {
    mounts = {
      enable = lib.mkEnableOption "Enable mounts in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
    ];
    fileSystems = builtins.listToAttrs (
      map
        (mount: {
          name = "/mnt/crusader/${mount}";
          value = {
            device = "crusader:/mnt/user/${mount}";
            fsType = "nfs";
            options = [
              "x-systemd.automount"
              "x-systemd.idle-timeout=600"
              "noauto"
              "noatime"
            ];
          };
        })
        [
          "Backup"
          "Downloads"
          "Games"
          "Life"
          "Media"
          "Miscellaneous"
          "Photos"
          "Projects"
        ]
    );
    services.rpcbind.enable = true;
  };
}
