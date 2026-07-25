{ inputs, ... }:
{
  flake-file.inputs.flake-parts = {
    inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    url = "github:hercules-ci/flake-parts";
  };

  imports = [ inputs.flake-parts.flakeModules.modules ];
}
