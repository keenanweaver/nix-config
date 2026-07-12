{
  configurations.nixos.nixos-desktop.module = { lib, pkgs, ... }: {
    boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
  };
}
