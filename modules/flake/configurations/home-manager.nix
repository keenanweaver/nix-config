{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;
in
{
  config.flake.homeConfigurations = mapAttrs (
    _name:
    { module, system }:
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        (
          { pkgs, ... }:
          {
            home._nixosModuleImported = true;
            nix = {
              package = pkgs.nix;
              settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
          }
        )
        module
      ];
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    }
  ) config.configurations.home-manager;
  options.configurations.home-manager = mkOption {
    default = { };
    type = types.lazyAttrsOf (
      types.submodule {
        options = {
          module = mkOption {
            type = types.deferredModule;
          };
          system = mkOption {
            default = "x86_64-linux";
            type = types.str;
          };
        };
      }
    );
  };
}
