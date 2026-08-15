{
  flake.modules.nixos.gaming-profile =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      chaotic.mesa-git.extraPackages = lib.mkIf config.chaotic.mesa-git.enable [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.low-latency-layer
      ];

      hardware.graphics.extraPackages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.low-latency-layer
      ];
    };
}
