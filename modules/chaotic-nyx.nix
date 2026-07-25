{ inputs, ... }:
{
  flake-file.inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  flake.modules.nixos.base-profile = {
    imports = [ inputs.chaotic.nixosModules.default ];
  };
}
