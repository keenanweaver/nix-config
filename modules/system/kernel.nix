{
  flake.modules.nixos.profile-base =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
