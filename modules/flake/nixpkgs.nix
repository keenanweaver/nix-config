{ inputs, lib, ... }:
{
  flake.modules.nixos.base-profile.nixpkgs = {
    config = {
      allowBroken = false;
      allowUnfree = true;
    };
    overlays = [
      (final: _prev: {
        nixpkgs-unstable = import inputs.nixpkgs-unstable {
          inherit (final) config;
          inherit (final.stdenv.hostPlatform) system;
        };
      })
      (final: _prev: {
        master = import inputs.nixpkgs-master {
          inherit (final) config;
          inherit (final.stdenv.hostPlatform) system;
        };
      })
    ];
  };
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  perSystem =
    { system, ... }:
    {
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
