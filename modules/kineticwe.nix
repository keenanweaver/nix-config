{
  flake.modules.nixos.kineticwe = { inputs, ... }: {
    imports = [ inputs.kineticwe.nixosModules.default ];
    programs.kineticwe.enable = true;
  };

  flake-file.inputs.kineticwe = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "gitlab:theblackdon/kineticwe";
  };
}
