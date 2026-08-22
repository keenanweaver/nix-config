{
  flake.modules.nixos.profile-gaming =
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
