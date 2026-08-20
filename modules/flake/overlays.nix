{
  flake.modules.nixos.base-profile.nixpkgs.overlays = [
    (_final: prev: {
      klassy = prev.klassy.overrideAttrs (
        finalAttrs: _prevAttrs: {
          version = "6.7.1";
          src = prev.fetchFromGitHub {
            owner = "paulmcauley";
            repo = "klassy";
            tag = "v${finalAttrs.version}";
            hash = "sha256-5sB8vBjxJ+7/YkJDC7GvOKt35wJCGnJLOQAYH6+qmoU=";
          };
        }
      );
    })
  ];
}
