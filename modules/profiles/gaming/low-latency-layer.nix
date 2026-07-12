{
  flake.modules.nixos.gaming-profile = { pkgs, inputs, ... }: {
    hardware.graphics.extraPackages = with pkgs; [
      inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.low-latency-layer
    ];
  };
}
