{ inputs, ... }:
{
  flake.modules.nixos.profile-base = { ... }: {
    imports = [
      inputs.nur.modules.nixos.default
      inputs.nyx.nixosModules.default
    ];
    nixpkgs.overlays = [
      inputs.nur.overlays.default
    ];
  };
  flake-file.inputs = {
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nur = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NUR";
    };
    nyx = {
      inputs.home-manager.follows = "home-manager";
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
  };
}
