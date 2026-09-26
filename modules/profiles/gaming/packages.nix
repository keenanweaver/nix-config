{ inputs, ... }:
{
  flake.modules.homeManager.profile-gaming =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          faugus-launcher
          local.game-wrapper
          local.portproton
          openspeedrun
          umu-launcher
          vermouth
          winetricks
        ]
        ++ [
          inputs.nur-packages-bandithedoge.legacyPackages.${pkgs.stdenv.hostPlatform.system}.winegui
          inputs.rom-properties-nix-flake.packages.${pkgs.stdenv.hostPlatform.system}.rp_kde6
        ];
    };
  flake-file.inputs = {
    nur-packages-bandithedoge = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:bandithedoge/nur-packages";
    };
    rom-properties-nix-flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/rom-properties-nix-flake";
    };
  };
}
