{
  flake-file.inputs = {
    hjem = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:feel-co/hjem";
    };
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };
}
