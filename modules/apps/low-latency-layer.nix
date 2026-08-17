{
  flake.modules.nixos.gaming-profile =
    { inputs, pkgs, ... }:
    {
      chaotic.mesa-git.extraPackages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.low-latency-layer
      ];
      hardware.graphics.extraPackages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.low-latency-layer
      ];
    };
}
