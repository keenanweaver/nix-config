{ inputs, ... }:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake.modules.nixos.base-profile = {
    imports = [
      inputs.disko.nixosModules.disko
    ];
  };
  flake-file.inputs.disko.url = "github:nix-community/disko";
}
