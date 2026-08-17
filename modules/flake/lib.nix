{ lib, ... }:
{
  config.flake.lib.packageListText =
    pkgs: packages:
    builtins.concatStringsSep "\n" (
      builtins.sort builtins.lessThan (pkgs.lib.lists.unique (map (p: p.name) packages))
    );
  options.flake.lib = lib.mkOption {
    default = { };
    description = "Helper functions shared across modules.";
    type = lib.types.lazyAttrsOf lib.types.raw;
  };
}
