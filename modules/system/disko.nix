{ inputs, ... }:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake.modules.nixos.profile-base.imports = [
    inputs.disko.nixosModules.disko
  ];
  flake-file.inputs.disko = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/disko";
  };
}
