{
  flake.modules.homeManager.fluxer =
    { inputs, pkgs, ... }:
    {
      home.packages = with pkgs; [
        inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.fluxer-desktop-canary
      ];
    };
}
