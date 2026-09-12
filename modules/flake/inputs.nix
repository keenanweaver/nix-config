{
  flake.modules.nixos.profile-base = { inputs, ... }: {
    imports = [
      inputs.omniflake.flakes.nur.modules.nixos.default
      inputs.nyx.nixosModules.default
      #inputs.omniflake.flakes.nixpkgs-multiverse.nixosModules.default
      #inputs.omniflake.flakes.hjem.nixosModules.default
      #inputs.omniflake.flakes.nixpak.nixosModules.default
      #inputs.omniflake.flakes.nix-wrapper-modules-nix-community.nixosModules.default
    ];
    nixpkgs.overlays = [
      inputs.omniflake.flakes.nix-gaming-edge.overlays.default
      inputs.omniflake.flakes.nur.overlays.default
    ];
  };
  flake-file.inputs.nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
}
