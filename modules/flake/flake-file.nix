{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-file.flakeModules.nix-auto-follow
  ];
  flake-file = {
    inputs.flake-file.url = "github:vic/flake-file";
    prune-lock.enable = true;
  };
}
