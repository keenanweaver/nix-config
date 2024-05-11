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
      ];
    };

    security = {
      pam = {
        loginLimits = [
          # Realtime audio
          #{ domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
          #{ domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
          #{ domain = "@realtime"; item = "memlock"; type = "-"; value = "unlimited"; }
          #{ domain = "@realtime"; item = "rtprio"; type = "-"; value = "99"; }
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
          #KERNEL=="rtc0", GROUP="audio"
          #KERNEL=="hpet", GROUP="audio"
        '';
      };
    };
    systemd = {
      extraConfig = ''
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=10s
      '';
    };

    /*
      systemd.services.speed-up-shutdown = {
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
      };
    */

    home-manager.users.${username} = { };
  };
}
