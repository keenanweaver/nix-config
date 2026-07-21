{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mapAttrsToList
    mkMerge
    mkOption
    nixosSystem
    types
    ;
in
{
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
  config.flake = {
    checks = mkMerge (
      mapAttrsToList (name: nixos: {
        ${nixos.config.nixpkgs.hostPlatform.system} = {
          "configurations/nixos/${name}" = nixos.config.system.build.toplevel;
        };
      }) config.flake.nixosConfigurations
    );
    nixosConfigurations = mapAttrs (
      _name:
      { module, system }:
      nixosSystem {
        modules = [
          {
            nixpkgs.hostPlatform = system;
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
          module
        ];
        specialArgs = { inherit inputs self; };
      }
    ) config.configurations.nixos;
  };
}
