{ inputs, ... }:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake.modules.nixos.base-profile = {
    imports = [
      inputs.disko.nixosModules.disko
    ];
  };
  flake-file.inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
  };
}
