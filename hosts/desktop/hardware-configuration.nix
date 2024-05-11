{ lib, username, ... }:
{
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "mode=755"
      "size=8G"
    ];
  };

  fileSystems."/home" = {
    options = [
      "compress=zstd"
      "subvol=home"
    ];
  };

  fileSystems."/nix" = {
    options = [
      "compress=zstd"
      "subvol=nix"
    ];
  };

  fileSystems."/persist" = {
    neededForBoot = true;
    options = [
      "compress=zstd"
      "subvol=persist"
    ];
  };

  fileSystems."/home/${username}/Games" = {
    depends = [ "/home" ];
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S620NJ0R902825F-part1";
    fsType = "btrfs";
    options = [
      "compress-force=zstd"
      "noatime"
    ];
  };

  # Disable swap
  swapDevices = lib.mkForce [ ];
}
