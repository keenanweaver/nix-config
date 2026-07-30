{
  flake.diskoConfigurations.nixos-htpc = {
    disko.devices = {
      disk.main = {
        content = {
          partitions = {
            esp = {
              content = {
                format = "vfat";
                mountOptions = [ "umask=0077" ];
                mountpoint = "/boot";
                type = "filesystem";
              };
              size = "1024M";
              type = "EF00";
            };
            root = {
              content = {
                extraArgs = [ "-Lnixos-htpc" ];
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
                    swap.swapfile.size = "8G";
                  };
                };
                type = "btrfs";
              };
              size = "100%";
            };
          };
          type = "gpt";
        };
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_M.2_1TB_S415NB0KC02763W";
        type = "disk";
      };
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "mode=755"
          "size=8G"
        ];
      };
    };
  };
}
