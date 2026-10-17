{ lib, ... }:
let
  directory = ../../pkgs;
  overlay = final: _prev: {
    local = final.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      inherit directory;
    };
  };
in
{
  flake = {
    modules.nixos.local-packages.nixpkgs.overlays = [ overlay ];
    overlays.local = overlay;
  };
  perSystem =
    { pkgs, ... }:
    {
      packages = lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        inherit directory;
      };
    };
}
