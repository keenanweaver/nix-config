{
  flake.modules.nixos.profile-gaming =
    { inputs, ... }:
    {
      imports = [ inputs.omniflake.flakes.wine-cachyos-nix.nixosModules.default ];
      nixpkgs.overlays = [ inputs.omniflake.flakes.wine-cachyos-nix.overlays.default ];
      programs.wine-cachyos = {
        enable = true;
        binfmt.enable = false;
        fontAliases.enable = true;
        ntsync.enable = true;
      };
    };
}
