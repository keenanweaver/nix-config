{
  flake.modules = {
    homeManager.profile-gaming =
      { inputs, ... }:
      {
        imports = [ inputs.omniflake.flakes.yeetmouse-nix.homeModules.default ];
        programs.yeetmouse.enable = true;
      };
    nixos.profile-gaming =
      { inputs, ... }:
      {
        imports = [ inputs.omniflake.flakes.yeetmouse-nix.nixosModules.default ];
        hardware.yeetmouse = {
          enable = true;
          sensitivity = 1.0;
        };
        nixpkgs.overlays = [ inputs.omniflake.flakes.yeetmouse-nix.overlays.default ];
      };
  };
}
