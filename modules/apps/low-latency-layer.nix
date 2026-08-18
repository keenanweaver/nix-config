{
  flake.modules.nixos.gaming-profile =
    { pkgs, ... }:
    {
      chaotic.mesa-git.extraPackages = with pkgs; [
        low-latency-layer
      ];
      hardware.graphics.extraPackages = with pkgs; [
        low-latency-layer
      ];
    };
}
