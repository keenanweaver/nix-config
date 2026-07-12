{
  configurations.nixos.nixos-htpc.module = { lib, pkgs, ... }: {
    boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
  };
}
