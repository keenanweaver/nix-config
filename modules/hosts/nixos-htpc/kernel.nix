{
  configurations.nixos.nixos-htpc.module =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
    };
}
