{
  flake.modules = {
    homeManager.gaming-profile = { pkgs, ... }: {
      home.packages = with pkgs; [ nero-umu ];
    };
    nixos.gaming-profile = {
      nixpkgs.overlays = [
        (_final: prev: {
          nero-umu = prev.nero-umu.overrideAttrs {
            src = prev.fetchFromGitHub {
              hash = "sha256-BLNrCJ0i/FVJ5Yr4kW0aGJTi4Gke5QOUr5AurYkdBGU=";
              owner = "KeyesTheWah";
              repo = "Nero-umu";
              rev = "ed64319af88c6d2d6cebfb1d15cf33ead07d3756";
            };
            version = "1.2.0-unstable-07-13-2026";
          };
        })
      ];
    };
  };
}
