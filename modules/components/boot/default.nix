{ pkgs, lib, ... }:
{

  boot = {
    binfmt = {
      emulatedSystems = [
        "aarch64-linux"
      ];
    };
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
      "zswap.enabled=0"
      # Quiet boot
      "quiet"
      # "splash" # Plymouth
      "loglevel=0"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
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
    plymouth.enable = false;
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
