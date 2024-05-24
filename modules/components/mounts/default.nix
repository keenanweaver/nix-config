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
          "noauto"
        ];
      };
      "${mountpoint}/Backup" = {
        device = "${server}:/mnt/user/Backup";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Downloads" = {
        device = "${server}:/mnt/user/Downloads";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/eXo" = {
        device = "${server}:/mnt/user/eXo";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Games" = {
        device = "${server}:/mnt/user/Games";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Life" = {
        device = "${server}:/mnt/user/Life";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Media" = {
        device = "${server}:/mnt/user/Media";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Miscellaneous" = {
        device = "${server}:/mnt/user/Miscellaneous";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Mister" = {
        device = "${server}:/mnt/user/Mister";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Photos" = {
        device = "${server}:/mnt/user/Photos";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
      "${mountpoint}/Projects" = {
        device = "${server}:/mnt/user/Projects";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
    services.rpcbind.enable = true;
    home-manager.users.${username} = { };
  };
}
