{ inputs, ... }:
{
  flake.modules.nixos.kineticwe = { ... }: {
    imports = [ inputs.kineticwe.nixosModules.default ];
    programs.kineticwe.enable = true;
  };
  flake-file.inputs.kineticwe = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "gitlab:theblackdon/kineticwe";
  };
}
