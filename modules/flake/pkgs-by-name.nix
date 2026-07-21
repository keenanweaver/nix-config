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
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
  flake.modules.nixos.local-packages = {
    nixpkgs.overlays = [ overlay ];
  };
  flake.overlays.local = overlay;
  flake-file.inputs.pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  perSystem.pkgsDirectory = ../../packages;
}
