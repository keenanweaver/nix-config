{
  flake.modules.nixos.profile-base =
    { lib, pkgs, ... }:
    {
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    };
}
