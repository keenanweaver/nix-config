{ inputs, withSystem, ... }:
let
  overlay =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        local = config.packages;
      }
    );
in
{
  imports = [ inputs.omniflake.flakes.pkgs-by-name-for-flake-parts.flakeModule ];
  flake = {
    modules.nixos.local-packages.nixpkgs.overlays = [ overlay ];
    overlays.local = overlay;
  };
  perSystem.pkgsDirectory = ../../pkgs;
}
