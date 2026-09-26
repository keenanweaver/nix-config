{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
    inputs.pedantix.flakeModules.default
  ];
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {
      pre-commit.settings.hooks = {
        check-added-large-files = {
          enable = true;
          excludes = [
            "\\.png"
            "\\.jpg"
          ];
        };
        check-case-conflicts.enable = true;
        check-executables-have-shebangs.enable = true;
        check-json.enable = true;
        check-merge-conflicts.enable = true;
        check-shebang-scripts-are-executable.enable = true;
        check-symlinks.enable = true;
        check-toml.enable = true;
        check-yaml.enable = true;
        commitizen.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer = {
          enable = true;
          excludes = [
            "^assets/secrets/"
            "facter\\.json$"
            "^flake\\.lock$"
          ];
        };
        eval-hosts = {
          enable = true;
          entry = lib.getExe (
            pkgs.writeShellApplication {
              name = "hook-eval-hosts";
              text = ''
                command -v nix >/dev/null || exit 0
                nix eval --json .#nixosConfigurations \
                  --apply 'builtins.mapAttrs (_: c: c.config.system.build.toplevel.drvPath)' >/dev/null
              '';
            }
          );
          files = "\\.(nix|lock)$";
          name = "eval-hosts";
          pass_filenames = false;
          stages = [ "pre-push" ];
        };
        flake-file = {
          enable = true;
          entry = lib.getExe (
            pkgs.writeShellApplication {
              name = "hook-check-flake-file";
              text = ''
                command -v nix >/dev/null || exit 0
                if ! nix build --no-link --quiet ".#checks.${system}.check-flake-file"; then
                  echo "flake.nix is out of date; run: nix run .#write-flake" >&2
                  exit 1
                fi
              '';
            }
          );
          files = "\\.nix$";
          name = "flake-file";
          pass_filenames = false;
        };
        forbid-new-submodules.enable = true;
        nixf-diagnose.enable = true;
        no-commit-to-branch = {
          enable = true;
          settings.branch = [ "main" ];
        };
        pre-commit-hook-ensure-sops = {
          enable = true;
          files = "^assets/secrets/.*\\.yaml$";
        };
        ripsecrets = {
          enable = true;
          excludes = [
            "\\.pub$"
            "assets/secrets/.*"
          ];
        };
        treefmt.enable = true;
        trim-trailing-whitespace = {
          enable = true;
          excludes = [
            "^assets/secrets/"
            "facter\\.json$"
            "^flake\\.lock$"
          ];
        };
        typos = {
          enable = true;
          settings.config = lib.importTOML ../../assets/typos.toml;
        };
      };
      treefmt = {
        imports = [
          inputs.json-sort.treefmtModules.default
        ];
        programs = {
          deadnix.enable = true;
          dos2unix.enable = true;
          json-sort.enable = true;
          jsonfmt.enable = true;
          just.enable = true;
          keep-sorted.enable = true;
          mdformat.enable = true;
          nixfmt.enable = true;
          pedantix = {
            enable = true;
            excludes = [
              "flake.nix"
            ];
          };
          qmlformat.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          statix = {
            enable = true;
            disabled-lints = [ "repeated_keys" ];
          };
          taplo.enable = true;
          xmllint.enable = true;
          yamlfmt.enable = true;
        };
        projectRootFile = "flake.nix";
        settings = {
          formatter = {
            deadnix.priority = 1;
            nixfmt.priority = 3;
            pedantix.priority = 4;
            statix.priority = 2;
          };
          global.excludes = [
            ".envrc"
            "*facter.json"
            "*keenan.yaml"
            "*nixos.yaml"
            "*.sops.yaml"
            "flake.lock"
            "result"
            "result-*"
            ".direnv/*"
            "*.age"
          ];
          on-unmatched = "info";
        };
      };
    };
  flake-file.inputs = {
    git-hooks-nix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/git-hooks.nix";
    };
    json-sort = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:drupol/json-sort";
    };
    pedantix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Swarsel/pedantix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };
}
