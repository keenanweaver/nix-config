{ inputs, home-manager, config, pkgs, lib, ... }: {

  boot = {
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    consoleLogLevel = 0;
    extraModulePackages = with config.boot.kernelPackages; [ ]; #v4l2loopback
    initrd = {
      systemd.enable = true;
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
    loader.systemd-boot.enable = lib.mkForce false;
    plymouth = {
      enable = true;
    };
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
