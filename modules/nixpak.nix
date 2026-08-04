{
  flake-file.inputs.nixpak = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nixpak/nixpak";
  };
}
