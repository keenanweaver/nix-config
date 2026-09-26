{ inputs, ... }:
{
  flake.modules.nixos.star-citizen =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.nix-citizen.nixosModules.default
      ];
      nix.settings = {
        extra-substituters = [ "https://nix-citizen.cachix.org" ];
        extra-trusted-public-keys = [
          "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        ];
      };
      programs.rsi-launcher = {
        enable = true;
        location = "/mnt/Games2/star-citizen";
        preCommands = ''
          ${lib.getExe pkgs.local.game-wrapper}
        '';
      };
    };
  flake-file.inputs.nix-citizen = {
    inputs = {
      flake-compat.follows = "flake-compat";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:LovingMelody/nix-citizen";
  };
}
