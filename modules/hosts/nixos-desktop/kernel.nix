{
  configurations.nixos.nixos-desktop.module =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
    };
}
