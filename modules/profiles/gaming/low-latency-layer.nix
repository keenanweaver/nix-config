{
  flake.modules.nixos.gaming-profile =
    { inputs, pkgs, ... }:
    {
      hardware.graphics.extraPackages = with pkgs; [
        inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.low-latency-layer
      ];
    };
}
