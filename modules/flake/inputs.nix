{
  flake.modules.nixos.profile-base = { inputs, ... }: {
    imports = [
      inputs.nur.modules.nixos.default
      inputs.nyx.nixosModules.default
    ];
    nixpkgs.overlays = [
      inputs.nix-gaming-edge.overlays.default
      inputs.nur.overlays.default
    ];
  };
  flake-file.inputs = {
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-gaming-edge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:powerofthe69/nix-gaming-edge";
    };
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
