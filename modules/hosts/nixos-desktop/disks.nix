{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    let
      user = config.users.users.${config.my.user};
    in
    {
      fileSystems = {
        "/mnt/Games" = {
          device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y515050E-part1";
          fsType = "btrfs";
          options = [
            "compress=zstd:3"
            "nofail"
            "x-systemd.device-timeout=10"
          ];
        };
        "/mnt/Games2" = {
          device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S620NJ0R902825F-part1";
          fsType = "btrfs";
          options = [
            "compress=zstd:3"
            "nofail"
            "x-systemd.device-timeout=10"
          ];
        };
        "/mnt/windows" = {
          device = "/dev/disk/by-id/nvme-WDS250G2X0C-00L350_182012421668_1-part3";
          fsType = "ntfs";
          options = [
            "uid=${toString user.uid}"
            "gid=${toString config.users.groups.${user.group}.gid}"
            "rw"
            "user"
            "exec"
            "umask=022"
            "nofail"
            "x-systemd.device-timeout=10"
          ];
        };
      };
    };
}
