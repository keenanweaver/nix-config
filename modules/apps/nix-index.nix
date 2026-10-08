{ inputs, ... }:
{
  flake.modules.nixos.profile-base.imports = [
    inputs.nix-index-database.nixosModules.default
  ];
  flake-file.inputs.nix-index-database = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/nix-index-database";
  };
}
