{ self, ... }:
{
  configurations.nixos.nixos-htpc.module =
    { pkgs, ... }:
    {
      imports = [ self.modules.nixos.cachyos-kernel ];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
    };
}
