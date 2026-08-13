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

    json-sort = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:drupol/json-sort";
    };

    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  perSystem = _: {
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

      editorconfig-checker = {
        enable = true;

        excludes = [
          "facter\\.json$"
        ];
      };

      forbid-new-submodules.enable = true;

      no-commit-to-branch = {
        enable = true;
        settings.branch = [ "main" ];
      };

      pre-commit-hook-ensure-sops.enable = true;

      ripsecrets = {
        enable = true;

        excludes = [
          "\\.pub$"
          "modules/sops/.*"
        ];
      };

      treefmt.enable = true;
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
        toml-sort.enable = true;
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
}
