{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.yeetmouse =
      { ... }:
      {
        imports = [ inputs.yeetmouse-nix.homeModules.default ];
        programs.yeetmouse.enable = true;
      };
    nixos.yeetmouse =
      { lib, config, ... }:
      {
        imports = [ inputs.yeetmouse-nix.nixosModules.default ];
        boot.kernelModules = lib.mkIf config.hardware.yeetmouse.enable [ "yeetmouse" ];
        hardware.yeetmouse = {
          enable = lib.mkDefault true;
          mode = lib.mkDefault {
            natural = {
              exponent = 1.0;
              midpoint = 0.0;
            };
          };
          sensitivity = lib.mkDefault 1.0;
        };
        home-manager.sharedModules = [ self.modules.homeManager.yeetmouse ];
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
