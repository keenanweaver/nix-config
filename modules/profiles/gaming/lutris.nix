{
  flake.modules.homeManager.gaming-profile =
    { inputs, pkgs, ... }:
    {
      programs.lutris = {
        enable = true;
        winePackages = with pkgs; [
          inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-cachyos
        ];
      };
    };
}
