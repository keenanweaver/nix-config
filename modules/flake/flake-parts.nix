{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake-file.inputs.flake-parts = {
    inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    url = "github:hercules-ci/flake-parts";
  };
}
