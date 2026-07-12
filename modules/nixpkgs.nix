{ inputs, ... }:
{
  flake.modules.nixos.base-profile = {
    nixpkgs.config = {
      allowBroken = false;
      allowUnfree = true;
    };
  };
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
  };
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.chaotic.overlays.default ];
    };
  };
}
