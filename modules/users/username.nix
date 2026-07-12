{
  flake.modules.nixos.base-profile = { lib, ... }: {
    options.my.user = lib.mkOption {
      default = "keenan";
      type = lib.types.str;
    };
  };
}
