{
  flake.modules.nixos.profile-gaming =
    { inputs, ... }:
    {
      imports = [ inputs.omniflake.flakes.eden-nix.nixosModules.default ];
      nixpkgs.overlays = [ inputs.omniflake.flakes.eden-nix.overlays.default ];
      programs.eden.enable = true;
    };
}
