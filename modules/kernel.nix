{
  flake.modules.nixos.base-profile = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
