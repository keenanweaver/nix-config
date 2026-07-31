{
  flake.modules = {
    homeManager.niri =
      {
        inputs,
        pkgs,
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

    nixos.niri =
      { inputs, ... }:
      {
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      };
  };
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
  };
}
