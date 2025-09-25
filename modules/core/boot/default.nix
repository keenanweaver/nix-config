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
        "kernel.soft_watchdog" = 0;
      };
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "nowatchdog"
      "zswap.enabled=0"
      # Quiet boot
      "quiet"
      "splash" # Plymouth
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
      limine = {
        enable = true;
        additionalFiles = {
          "efi/memtest86/memtest.efi" = "${pkgs.memtest86plus}/memtest.efi";
          "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
        };
        extraEntries = ''
          /+Tools
          //MemTest86
            protocol: efi
            path: boot():/limine/efi/memtest86/memtest.efi
          //Netboot.xyz
            protocol: efi
            path: boot():/limine/efi/netbootxyz/netboot.xyz.efi
        '';
        secureBoot = {
          enable = false;
        };
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
