{
  flake.modules.homeManager.profile-base =
    { inputs, ... }:
    {
      imports = [
        inputs.pedantix.homeModules.default
      ];
      programs.pedantix = {
        enable = true;
        settings = {
          lets.sort = true;
          preset = "nixos-module";
        };
      };
    };
  flake-file.inputs.pedantix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:swarsel/pedantix";
  };
}
