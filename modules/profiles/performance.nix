{
  lib,
  config,
  username,
  ...
}:
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
        };
      };
      kernelParams = [
        "loglevel=0"
        "nmi_watchdog=0"
        "nowatchdog"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
      ];
    };

    services = {
      journald = {
        extraConfig = ''
          SystemMaxUse=50M
        '';
      };
      # Pending https://github.com/NixOS/nixpkgs/pull/352300
      scx.enable = true;
      udev = {
        extraRules = ''
          # https://wiki.archlinux.org/title/Improving_performance#Changing_I/O_scheduler
          # HDD
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

          # SSD
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

          # NVMe SSD
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
        '';
      };
    };
    systemd = {
      extraConfig = ''
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=10s
      '';
    };

    home-manager.users.${username} = { };
  };
}
