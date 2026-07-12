{ inputs, ... }:
{
  flake-file.inputs.systems.url = "github:nix-systems/default-linux";

  systems = import inputs.systems;
}
