{
  flake.modules.homeManager.gaming-profile = { pkgs, inputs, ... }: {
    programs.lutris = {
      enable = true;
      winePackages = with pkgs; [
        inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-tkg
      ];
    };
  };
}
