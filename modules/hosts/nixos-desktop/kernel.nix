{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { config, pkgs, ... }:
    {
      imports = [ self.modules.nixos.cachyos-kernel ];
      boot = {
        extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
        kernelModules = [ "nct6687" ];
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
      };
    };
}
