{ lib, username, ... }:
{
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "mode=755"
      "size=16G"
    ];
  };

  fileSystems."/home" = {
    options = [
      "compress=zstd:1"
      "subvol=home"
    ];
  };

  fileSystems."/nix" = {
    options = [
      "compress=zstd:1"
      "subvol=nix"
    ];
  };

  fileSystems."/persist" = {
    neededForBoot = true;
    options = [
      "compress=zstd:1"
      "subvol=persist"
    ];
  };

  fileSystems."/home/${username}/Games" = {
    depends = [ "/home" ];
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S73WNJ0TB09290J-part1";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
    ];
  };

  fileSystems."/home/${username}/.local/share/games" = {
    depends = [ "/home" ];
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S620NJ0R902825F-part1";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-id/nvme-WDS250G2X0C-00L350_182012421668_1-part3";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };

  # Disable swap
  swapDevices = lib.mkForce [ ];
}
