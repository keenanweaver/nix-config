{ inputs, ... }:
{
  flake.modules.nixos.base-profile = {
    imports = [ inputs.chaotic.nixosModules.default ];
  };
  flake-file.inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
}
