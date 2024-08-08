{
  config,
  pkgs,
  lib,
  ...
}:
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
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "vm.swappiness" = 10;
      };
    };
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_9; # use until pipewire stops crackling
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "splash"
      #"systemd.unified_cgroup_hierarchy=1"
      "udev.log_level=3"
      "udev.log_priority=3"
      "zswap.enabled=0"
    ];
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
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
