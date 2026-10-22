{ inputs, ... }:
{
  flake.modules.homeManager.steam-config = {
    imports = [
      inputs.steam-config-nix.homeModules.default
    ];
    programs.steam.config = {
      enable = true;
      apps."993090" = {
        betaBranch = "lsfg-vk";
        name = "Lossless Scaling";
      };
      defaultCompatTool = "Proton-Wineland Latest";
      displayRatesAsBits = false;
      onSteamRunning = "close";
    };
  };
  flake-file.inputs.steam-config-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      systems.follows = "flake-utils/systems";
    };
    url = "github:different-name/steam-config-nix";
  };
}
