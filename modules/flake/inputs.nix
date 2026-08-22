{
  flake.modules.nixos.profile-base = { inputs, ... }: {
    imports = [
      inputs.chaotic.nixosModules.default
      inputs.nur.modules.nixos.default
    ];
    nixpkgs.overlays = [
      inputs.nix-gaming-edge.overlays.default
      inputs.nur.overlays.default
    ];
  };
  flake-file.inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };

    /*
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
