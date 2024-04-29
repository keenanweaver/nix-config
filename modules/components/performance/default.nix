{ lib, config, username, ... }:
let
  cfg = config.performance;
in
{
  options = {
    performance = {
      enable = lib.mkEnableOption "Enable performance in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      kernel = {
        sysctl = {
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/etc/sysctl.d/99-cachyos-settings.conf
          "fs.file-max" = 2097152;
          "fs.inotify.max_user_watches" = 524288;
          "net.core.netdev_max_backlog" = 16384;
          "net.core.somaxconn" = 8192;
          "net.ipv4.tcp_slow_start_after_idle" = 0;
          #"split_lock_mitigate" = 0; # https://reddit.com/r/linux_gaming/comments/1bgqfuk/god_of_war_poor_performance/kv8xsae/?context=3
          "vm.max_map_count" = 1085476;
        };
      };
      kernelParams = [
        "loglevel=0"
        "nmi_watchdog=0"
        "nowatchdog"
        "split_lock_detect=off"
      ];
    };
    security = {
      pam = {
        loginLimits = [
          # https://scribe.rip/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577
          # https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732390362
          # https://github.com/CachyOS/CachyOS-Settings/tree/master/etc/security/limits.d
          { domain = "*"; item = "nofile"; type = "-"; value = "unlimited"; }
          { domain = "*"; item = "memlock"; type = "-"; value = "unlimited"; } # RPCS3
          { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; } # Realtime audio
          { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
          { domain = "@realtime"; item = "memlock"; type = "-"; value = "unlimited"; }
          { domain = "@realtime"; item = "rtprio"; type = "-"; value = "99"; }
        ];
      };
    };
    services = {
      journald = {
        extraConfig = ''
          SystemMaxUse=50M
        '';
      };
      udev = {
        extraRules = ''
          # https://wiki.archlinux.org/title/Improving_performance#Changing_I/O_scheduler
          # HDD
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

          # SSD
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

          # NVMe SSD
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

          # Realtime Audio (https://gentoostudio.org/?page_id=420)
          KERNEL=="rtc0", GROUP="audio"
          KERNEL=="hpet", GROUP="audio"
        '';
      };
    };
    systemd = {
      tmpfiles = {
        rules = [
          # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent
          "w /proc/sys/vm/compaction_proactiveness - - - - 0"
          "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
          "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
          "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
          ## CS2
          #"w /sys/kernel/mm/transparent_hugepage/enabled - - - - never"
          #"w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - never"
          #"w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 0"
          "w /proc/sys/vm/page_lock_unfairness - - - - 1"
          "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
          "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
          "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 500"
          "w /sys/kernel/debug/sched/latency_ns  - - - - 1000000"
          "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
          "w /sys/kernel/debug/sched/min_granularity_ns - - - - 500000"
          "w /sys/kernel/debug/sched/wakeup_granularity_ns  - - - - 0"
          "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/etc/tmpfiles.d/thp.conf
          "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
        ];
      };
      extraConfig = ''
        DefaultLimitNOFILE=2048:2097152
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=10s
      '';
      user = {
        extraConfig = ''
          DefaultLimitNOFILE=1024:1048576"
        '';
      }; # RPCS3
    };

    /*     systemd.services.speed-up-shutdown = {
      description = "Speeds up shutdown and reboot";
      wantedBy = [ "shutdown.target" ];
      before = [ "shutdown.target" ];
      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = "0";
      };
      script = ''
        /home/${username}/.local/bin/gsr-stop-replay.sh
        podman stop -a
      '';
    }; */

    home-manager.users.${username} = { };
  };
}
