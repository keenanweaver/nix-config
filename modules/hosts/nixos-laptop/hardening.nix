{
  configurations.nixos.nixos-laptop.module =
    { lib, ... }:
    {
      nix-mineral.settings.kernel = {
        iommu-passthrough = lib.mkForce true; # if false, boot doesn't work
        strict-iommu = false; # if true, boot doesn't work
      };
    };
}
