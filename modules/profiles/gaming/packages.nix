{
  flake.modules.homeManager.profile-gaming =
    { inputs, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          faugus-launcher
          local.game-wrapper
          local.portproton
          openspeedrun
          umu-launcher
          vermouth
          winetricks
        ]
        ++ [
          inputs.omniflake.flakes.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-cachyos
          inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${pkgs.stdenv.hostPlatform.system}.winegui
          inputs.omniflake.flakes.rom-properties-nix-flake.packages.${pkgs.stdenv.hostPlatform.system}.rp_kde6
        ];
    };
}
