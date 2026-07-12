{
  flake.diskoConfigurations.nixos-laptop = {
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
            luks = {
              content = {
                content = {
                  extraArgs = [ "-Lnixos-laptop" ];
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
                name = "nixos-laptop";
                settings.allowDiscards = true;
                type = "luks";
              };
              size = "100%";
            };
          };
          type = "gpt";
        };
        device = "/dev/disk/by-id/nvme-eui.5cd2e48231514cb8";
        type = "disk";
      };
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "mode=755"
          "size=4G"
        ];
      };
    };
  };
}
