{
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "relatime"
      "mode=755"
      "size=75%"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "btrfs";
    options = [
      "noatime"
      "subvol=swap"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
}
