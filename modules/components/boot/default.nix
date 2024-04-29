{ config, pkgs, lib, ... }: {

  boot = {
    consoleLogLevel = 0;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
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
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
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
      #systemd-boot.enable = lib.mkDefault false;
      timeout = 1;
    };
    plymouth.enable = true;
    supportedFilesystems = [
      "btrfs"
      "cifs"
      "fat"
      "ntfs"
    ];
  };
  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
