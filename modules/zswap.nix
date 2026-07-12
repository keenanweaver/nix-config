{
  flake.modules.nixos.base-profile = {
    boot.zswap.enable = true;
  };
}
