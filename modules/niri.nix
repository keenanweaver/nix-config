{
  flake.modules = {
    homeManager.niri =
      {
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [
          inputs.niri.homeModules.niri
        ];
        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
    nixos.niri = { inputs, ... }: {
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    };
  };
  flake-file.inputs = {
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sodiboo/niri-flake";
    };
  };
}
