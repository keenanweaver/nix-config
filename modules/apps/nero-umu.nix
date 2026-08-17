{
  flake.modules = {
    homeManager.gaming-profile =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ nero-umu ];
      };
    nixos.gaming-profile.nixpkgs.overlays = [
      (_final: prev: {
        nero-umu = prev.nero-umu.overrideAttrs (_oldAttrs: {
          version = "1.2.0-unstable-2026-07-18";
          src = prev.fetchFromGitHub {
            hash = "sha256-lES7s5cqOCuqjh+wVkzQOQ733Tu+6t4rpa8EdDg76Bs=";
            owner = "KeyesTheWah";
            repo = "Nero-umu";
            rev = "262fd20c105a5d586a877136c9c0d947ac0f5b34";
          };
        });
      })
    ];
  };
}
