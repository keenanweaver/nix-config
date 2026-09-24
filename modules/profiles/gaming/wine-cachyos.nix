{
  flake.modules.nixos.profile-gaming =
    { inputs, ... }:
    {
      imports = [ inputs.wine-cachyos-nix.nixosModules.default ];
      nixpkgs.overlays = [ inputs.wine-cachyos-nix.overlays.default ];
      programs.wine-cachyos = {
        enable = true;
        binfmt.enable = false;
        fontAliases.enable = true;
      };
    };
  flake-file.inputs.wine-cachyos-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/wine-cachyos-nix";
  };
}
