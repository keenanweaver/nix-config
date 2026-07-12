{
  flake.modules.nixos.gaming-profile = { pkgs, ... }: {
    boot = {
      kernel.sysctl = {
        # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/70-cachyos-settings.conf
        "fs.file-max" = 2097152;
        "kernel.split_lock_mitigate" = 0;
        "net.core.netdev_max_backlog" = 4096;
        "net.ipv4.tcp_fin_timeout" = 5;
        "vm.dirty_background_bytes" = 67108864;
        "vm.dirty_bytes" = 268435456;
        "vm.dirty_writeback_centisecs" = 1500;
        "vm.vfs_cache_pressure" = 50;
      };
    };
    services = {
      udev = {
        packages = with pkgs; [
          # https://wiki.cachyos.org/configuration/general_system_tweaks/#how-to-enable-adios
          (writeTextFile {
            destination = "/etc/udev/rules.d/60-ioschedulers.rules";
            name = "60-ioschedulers.rules";
            text = ''
              # HDD
              ACTION!="remove", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
              # SSD
              ACTION!="remove", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
              # NVMe SSD
              ACTION!="remove", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
            '';
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/69-hdparm.rules
          (writeTextFile {
            destination = "/etc/udev/rules.d/69-hdparm.rules";
            name = "69-hdparm.rules";
            text = ''
              ACTION!="remove", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${lib.getExe hdparm} -B 254 -S 0 /dev/%k"
            '';
          })
        ];
      };
    };
    systemd = {
      settings.Manager = {
        # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/systemd/system.conf.d/10-limits.conf
        DefaultLimitNOFILE = "2048:2097152";
      };
    };
  };
}
