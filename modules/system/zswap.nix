{ lib, ... }:
{
  flake.modules.nixos.profile-base.boot.zswap.enable = lib.mkDefault true;
}
