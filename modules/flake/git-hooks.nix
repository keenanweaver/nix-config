{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
    inputs.pedantix.flakeModules.default
  ];

  flake-file.inputs = {
    git-hooks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/git-hooks.nix";
    };

    json-sort.url = "github:drupol/json-sort";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  perSystem =
    { pkgs, ... }:
    {
      pre-commit.settings.hooks = {
        check-added-large-files.enable = true;
        check-case-conflicts.enable = true;
        check-json.enable = true;
        check-merge-conflicts.enable = true;
        check-shebang-scripts-are-executable.enable = false;
        check-toml.enable = true;
        check-yaml.enable = true;
        detect-private-keys.enable = true;

        editorconfig-checker = {
          enable = true;

          excludes = [
            "facter\\.json$"
          ];
        };

        end-of-file-fixer = {
          enable = true;

          excludes = [
            "facter\\.json$"
            "flake\\.lock$"
          ];
        };

        fix-byte-order-marker = {
          enable = true;

          excludes = [
            "facter\\.json$"
            "flake\\.lock$"
          ];
        };

        flake-checker.enable = true;

        mixed-line-endings = {
          enable = true;

          excludes = [
            "facter\\.json$"
            "flake\\.lock$"
          ];
        };

        no-commit-to-branch.enable = true;

        ripsecrets = {
          enable = true;
          excludes = [ "\\.pub$" ];
        };

        treefmt.enable = true;

        trim-trailing-whitespace = {
          enable = true;

          excludes = [
            "facter\\.json$"
            "flake\\.lock$"
          ];
        };

        /*
          typos = {
                 enable = true;

                 excludes = [
                   "flake\\.lock$"
                   "facter\\.json$"
                 ];
               };
        */
      };

      treefmt = {
        imports = [
          inputs.json-sort.treefmtModules.default
        ];

        programs = {
          deadnix.enable = true;

          json-sort = {
            enable = true;
            excludes = [ "facter.json" ];
          };

          jsonfmt = {
            enable = true;
            excludes = [ "facter.json" ];
          };

          just.enable = true;
          keep-sorted.enable = true;
          mdformat.enable = true;

          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rs;
          };

          pedantix = {
            enable = true;

            excludes = [
              "flake.nix"
              "*/package.nix"
            ];
          };

          shellcheck.enable = true;
          shfmt.enable = true;
          statix.enable = true;
          taplo.enable = true;
          yamlfmt.enable = true;
        };

        projectRootFile = "flake.nix";

        settings = {
          global.excludes = [
            "*facter.json"
            "*keenan.yaml"
            "*nixos.yaml"
            "*.sops.yaml"
            "flake.lock"
          ];

          json-sort.excludes = [ "facter.json" ];
          jsonfmt.excludes = [ "facter.json" ];
          on-unmatched = "warn";
        };
      };
    };
}
