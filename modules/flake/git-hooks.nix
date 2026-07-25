{ inputs, ... }:
{
  flake-file.inputs = {
    git-hooks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/git-hooks.nix";
    };

    json-sort.url = "github:drupol/json-sort";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
    inputs.pedantix.flakeModules.default
  ];

  perSystem = { pkgs, ... }: {
    treefmt = {
      imports = [
        inputs.json-sort.treefmtModules.default
      ];

      programs = {
        deadnix.enable = true;
        json-sort.enable = true;
        jsonfmt.enable = true;
        just.enable = true;

        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rs;
        };

        pedantix = {
          enable = true;

          excludes = [
            "flake.nix"
          ];

          settings = {
            lets.sort = true;
            preset = "nixos-module";
          };
        };

        shfmt.enable = true;
        statix.enable = true;
        yamlfmt.enable = true;
      };

      projectRootFile = "flake.nix";

      settings = {
        on-unmatched = "warn";
      };
    };
  };
}
