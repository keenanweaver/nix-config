{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { pkgs, ... }:
    {
      imports = [ self.modules.nixos.cachyos-kernel ];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
    };
}
