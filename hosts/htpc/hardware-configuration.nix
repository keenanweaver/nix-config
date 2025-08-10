{ lib, username, ... }:
{
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "defaults"
      "mode=755"
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

  # Disable swap
  swapDevices = lib.mkForce [ ];
}
