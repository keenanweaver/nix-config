{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.pedantix.flakeModules.git-hooks
  ];
  flake-file.inputs.git-hooks-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:cachix/git-hooks.nix";
  };
  perSystem = { lib, pkgs, ... }: {
    pre-commit.settings.hooks = {
      check-added-large-files.enable = true;
      check-case-conflicts.enable = true;
      check-merge-conflicts.enable = true;
      deadnix.enable = true;
      detect-private-keys.enable = true;
      editorconfig-checker = {
        enable = true;
        excludes = [
          "facter\\.json$"
        ];
      };
      just-fmt = {
        enable = true;
        entry = "${lib.getExe pkgs.just} --fmt --unstable";
        files = "^(.*\\.just|[Jj]ustfile)$";
        name = "just fmt";
        pass_filenames = false;
      };
      mdformat.enable = true;
      nixfmt.enable = true;
      pedantix.enable = true;
      ripsecrets = {
        enable = true;
        excludes = [ "\\.pub$" ];
      };
      shellcheck = {
        enable = true;
        excludes = [ "^\\.envrc$" ];
      };
      statix = {
        enable = true;
        excludes = [ "^.direnv/" ];
      };
    };
  };
}
