{
  flake.modules.homeManager.fluxer = { pkgs, inputs, ... }: {
    home.packages = with pkgs; [
      inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.fluxer-desktop-canary
    ];
  };
}
