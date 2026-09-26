{ inputs, ... }:
let
  channelsOverlay =
    final: _prev:
    let
      importChannel =
        nixpkgs:
        import nixpkgs {
          inherit (final) config;
          inherit (final.stdenv.hostPlatform) system;
        };
    in
    {
      master = importChannel inputs.nixpkgs-master;
      unstable = importChannel inputs.nixpkgs-unstable;
    };
in
{
  flake.modules.nixos.profile-base =
    { lib, config, ... }:
    {
      config.nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = config.my.permittedInsecurePackages;
        };
        overlays = [ channelsOverlay ];
      };
      options.my.permittedInsecurePackages = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
      };
    };
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nyx.overlays.default
          channelsOverlay
        ];
      };
    };
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
}
