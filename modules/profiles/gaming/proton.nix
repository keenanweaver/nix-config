{ inputs, ... }:
{
  flake.modules = {
    homeManager.gaming-profile =
      { lib, pkgs, ... }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
        ];
      in
      {
        home.packages = with pkgs; [ local.protonplus ];
        programs.lutris.protonPackages = steamCompatTools;

        xdg.dataFile = lib.genAttrs' steamCompatTools (
          tool:
          lib.nameValuePair "Steam/compatibilitytools.d/${lib.getName tool}" {
            source = tool.steamcompattool;
          }
        );
      };

    nixos.gaming-profile =
      { pkgs, ... }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
        ];
      in
      {
        nixpkgs.overlays = [
          (_final: prev: {
            proton-cachyos = inputs.nix-gaming-edge.packages.${prev.stdenv.hostPlatform.system}.proton-cachyos;
          })
        ];

        programs.steam.extraCompatPackages = steamCompatTools;
      };
  };
}
