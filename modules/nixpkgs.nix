{ inputs, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
  };

  flake.modules.nixos.base-profile = {
    nixpkgs.config = {
      allowBroken = false;
      allowUnfree = true;
    };
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;

      overlays = [
        inputs.chaotic.overlays.default
        (final: _prev: {
          master = import inputs.nixpkgs-master {
            inherit (final) config;
            inherit system;
          };
        })
        (final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final) config;
            inherit system;
          };
        })
      ];
    };
  };
}
