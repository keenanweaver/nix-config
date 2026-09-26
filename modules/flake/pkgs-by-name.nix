{ inputs, ... }:
let
  overlay = final: _prev: {
    local = final.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ../../pkgs;
    };
  };
in
{
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
  flake = {
    modules.nixos.local-packages.nixpkgs.overlays = [ overlay ];
    overlays.local = overlay;
  };
  perSystem.pkgsDirectory = ../../pkgs;
  flake-file.inputs.pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
}
