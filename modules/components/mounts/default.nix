{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.mounts;
  server = "crusader";
  mountpoint = "/mnt/${server}";
in
{
  options = {
    mounts = {
      enable = lib.mkEnableOption "Enable mounts in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
    ];
    fileSystems = {
      "${mountpoint}/appdata" = {
        device = "${server}:/mnt/user/appdata";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Backup" = {
        device = "${server}:/mnt/user/Backup";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Downloads" = {
        device = "${server}:/mnt/user/Downloads";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/eXo" = {
        device = "${server}:/mnt/user/eXo";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Games" = {
        device = "${server}:/mnt/user/Games";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Life" = {
        device = "${server}:/mnt/user/Life";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Media" = {
        device = "${server}:/mnt/user/Media";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Miscellaneous" = {
        device = "${server}:/mnt/user/Miscellaneous";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Mister" = {
        device = "${server}:/mnt/user/Mister";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Photos" = {
        device = "${server}:/mnt/user/Photos";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
      "${mountpoint}/Projects" = {
        device = "${server}:/mnt/user/Projects";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "rw"
        ];
      };
    };
    services.rpcbind.enable = true;
    home-manager.users.${username} = { };
  };
}
