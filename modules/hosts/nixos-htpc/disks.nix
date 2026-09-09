{
  configurations.nixos.nixos-htpc.module.fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S73WNJ0TB09290J-part1";
    fsType = "btrfs";
    options = [
      "compress=zstd:3"
      "nofail"
    ];
  };
}
