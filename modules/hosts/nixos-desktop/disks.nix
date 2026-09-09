{
  configurations.nixos.nixos-desktop.module.fileSystems = {
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
      ];
    };
    "/mnt/windows" = {
      device = "/dev/disk/by-id/nvme-WDS250G2X0C-00L350_182012421668_1-part3";
      fsType = "ntfs";
      options = [
        "uid=1000"
        "gid=1000"
        "rw"
        "user"
        "exec"
        "umask=000"
      ];
    };
  };
}
