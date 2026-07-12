{
  flake.modules = {
    nixos.base-profile = { inputs, ... }: {
      imports = [
        inputs.nur.modules.nixos.default
      ];
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
    };
  };
  flake-file.inputs = {
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
  };
}
