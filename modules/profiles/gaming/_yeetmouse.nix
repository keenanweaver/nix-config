{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-gaming =
      { ... }:
      {
        imports = [ inputs.yeetmouse-nix.homeModules.default ];
        programs.yeetmouse.enable = true;
      };
    nixos.profile-gaming =
      { ... }:
      {
        imports = [ inputs.yeetmouse-nix.nixosModules.default ];
        hardware.yeetmouse = {
          enable = true;
          sensitivity = 1.0;
        };
        nixpkgs.overlays = [ inputs.yeetmouse-nix.overlays.default ];
      };
  };
  flake-file.inputs.yeetmouse-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/yeetmouse-nix";
  };
}
