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
    mkOption
    types
    ;
in
{
  config.flake.homeConfigurations = mapAttrs (
    _name:
    { module, system }:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs self; };

      modules = [
        (
          { pkgs, ... }:
          {
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

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      };
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
