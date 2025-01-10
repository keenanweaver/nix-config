{ pkgs, lib, ... }:
{

  boot = {
    consoleLogLevel = 0;
    initrd = {
      systemd.enable = true; # Plymouth login screen
      verbose = false;
    };
    kernel = {
      sysctl = {
        "kernel.sysrq" = 4;
        "kernel.nmi_watchdog" = 0;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "vm.swappiness" = 10;
      };
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "nowatchdog"
      #"systemd.unified_cgroup_hierarchy=1"
      "zswap.enabled=0"
      # Quiet boot
      "quiet"
      "splash"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "loglevel=0"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 1;
    };
    plymouth.enable = true;
    supportedFilesystems = [
      "btrfs"
      "cifs"
      "ext4"
      "fat"
      "ntfs"
    ];
  };
  environment.systemPackages = with pkgs; [ sbctl ];
}
