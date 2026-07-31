{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-file.flakeModules.allfollow
  ];
  flake-file.inputs.flake-file.url = "github:vic/flake-file";
}
