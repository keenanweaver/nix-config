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
          inputs.omniflake.flakes.nix-gaming.packages.${system.stdenv.hostPlatform}.wine-cachyos
          inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${system.stdenv.hostPlatform}.winegui
          inputs.omniflake.flakes.rom-properties-nix-flake.packages.${system.stdenv.hostPlatform}.rp_kde6
        ];
    };
}
