{ lib, ... }:
{
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "mode=755"
      "size=4G"
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

  /*
    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/2ea2ee7f-dc13-4f59-9ca9-3c32d55ebd99";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=home" ];
      };

      fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/2ea2ee7f-dc13-4f59-9ca9-3c32d55ebd99";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=nix" ];
      };

      fileSystems."/persist" = {
      neededForBoot = true;
      device = "/dev/disk/by-uuid/2ea2ee7f-dc13-4f59-9ca9-3c32d55ebd99";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=persist" ];
    };
  */

  # Disable swap
  swapDevices = lib.mkForce [ ];
}
