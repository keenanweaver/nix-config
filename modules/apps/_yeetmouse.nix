{ inputs, ... }:
{
  flake.modules.nixos.yeetmouse =
    { lib, config, ... }:
    {
      imports = [ inputs.yeetmouse-nix.nixosModules.default ];
      hardware.yeetmouse = {
        enable = lib.mkDefault true;
        mode = lib.mkDefault {
          natural = {
            limit = 1.0;
            midpoint = 0.0;
          };
        };
        sensitivity = lib.mkDefault 1.0;
      };
      users.users.${config.my.user}.extraGroups = lib.mkIf config.hardware.yeetmouse.enable [
        "yeetmouse"
      ];
    };
  flake-file.inputs.yeetmouse-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      git-hooks.follows = "git-hooks-nix";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/yeetmouse-nix";
  };
}
