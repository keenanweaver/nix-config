{
  flake.modules.nixos.profile-base.nixpkgs.overlays = [
    (_final: prev: {
      # https://github.com/NixOS/nixpkgs/pull/561681
      klassy = prev.klassy.overrideAttrs (_old: {
        version = "6.7.2";
        src = prev.fetchFromGitHub {
          owner = "paulmcauley";
          repo = "klassy";
          tag = "v6.7.2";
          hash = "sha256-z8BXruvsrLz2Fyj1UIkEEiml5ZBoxlogSeRGxZ5holY=";
        };
      });
    })
  ];
}
