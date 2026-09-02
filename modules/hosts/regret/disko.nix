let
  device = "/dev/mmcblk0";
  mainDisk = {
    inherit device;
    content = {
      partitions = {
        firmware = {
          content = {
            format = "vfat";
            mountOptions = [ "umask=0077" ];
            mountpoint = "/boot/firmware";
            type = "filesystem";
          };
          size = "512M";
          type = "EF00";
        };
        root = {
          content = {
            extraArgs = [ "-Lregret" ];
            subvolumes = {
              "/home" = {
                mountOptions = [ "compress=zstd:3" ];
                mountpoint = "/home";
              };
              "/nix" = {
                mountOptions = [
                  "compress=zstd:3"
                  "noatime"
                ];
                mountpoint = "/nix";
              };
              "/persist" = {
                mountOptions = [
                  "compress=zstd:3"
                  "noatime"
                ];
                mountpoint = "/persist";
              };
              "/swap" = {
                mountpoint = "/swap";
                swap.swapfile.size = "4G";
              };
            };
            type = "btrfs";
          };
          size = "100%";
        };
      };
      type = "gpt";
    };
    type = "disk";
  };
in
{
  flake.diskoConfigurations.regret.disko.devices = {
    disk.main = mainDisk;
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "mode=755"
        "size=2G"
      ];
    };
  };
}
