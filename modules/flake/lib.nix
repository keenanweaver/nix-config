{ lib, ... }:
{
  options.flake.lib = lib.mkOption {
    default = { };
    description = "Helper functions shared across modules.";
    type = lib.types.lazyAttrsOf lib.types.raw;
  };
}
