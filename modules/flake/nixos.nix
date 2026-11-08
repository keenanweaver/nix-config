{
  self,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mapAttrsToList
    mkMerge
    mkOption
    types
    ;
in
{
  config = {
    flake = {
      checks = mkMerge (
        mapAttrsToList (name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system} = {
            "configurations/nixos/${name}" = nixos.config.system.build.toplevel;
          };
        }) config.flake.nixosConfigurations
      );
      nixosConfigurations = mapAttrs (
        name:
        { module, system }:
        inputs.nixpkgs-patcher.lib.nixosSystem {
          modules = [
            {
              networking.hostName = name;
              nixpkgs.hostPlatform = system;
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
            module
          ];
          nixpkgsPatcher.inputs = inputs;
        }
      ) config.configurations.nixos;
    };
    flake-file.inputs.nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
  };
  options.configurations.nixos = mkOption {
    type = types.lazyAttrsOf (
      types.submodule {
        options = {
          module = mkOption { type = types.deferredModule; };
          system = mkOption {
            default = "x86_64-linux";
            type = types.str;
          };
        };
      }
    );
  };
}
