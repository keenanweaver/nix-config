{
  flake.modules.nixos.profile-base = { inputs, ... }: {
    imports = [
      inputs.omniflake.flakes.nyx.nixosModules.default
      inputs.omniflake.flakes.nur.modules.nixos.default
    ];
    nixpkgs.overlays = [
      inputs.omniflake.flakes.nix-gaming-edge.overlays.default
      inputs.omniflake.flakes.nur.overlays.default
    ];
  };
  flake-file.inputs = {
    /*
        multiverse.url = "github:fzakaria/nixpkgs-multiverse";

        hjem = {
           inputs.nixpkgs.follows = "nixpkgs";
           url = "github:feel-co/hjem";
         };

        nixpak = {
           inputs.nixpkgs.follows = "nixpkgs";
           url = "github:nixpak/nixpak";
         };

      wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    */
  };
}
