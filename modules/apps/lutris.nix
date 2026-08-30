{
  flake.modules.homeManager.profile-gaming =
    { inputs, pkgs, ... }:
    {
      programs.lutris = {
        enable = true;
        winePackages = with pkgs; [
          inputs.omniflake.flakes.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-cachyos
        ];
      };
    };
}
