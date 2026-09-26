{ inputs, ... }:
{
  systems = import inputs.systems;
  flake-file.inputs.systems.url = "github:nix-systems/default-linux";
}
