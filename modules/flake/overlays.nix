{
  flake.modules.nixos.profile-base.nixpkgs.overlays = [
    (_final: prev: {
      # https://github.com/NixOS/nixpkgs/pull/561681
      klassy = prev.klassy.overrideAttrs (_old: {
        version = "6.7.3";
        src = prev.fetchFromGitHub {
          owner = "paulmcauley";
          repo = "klassy";
          tag = "v6.7.3";
          hash = "sha256-Uk4uB1dzm4aA6pHeYTgvFBf5CVbAsxoWYJYGkCzxGfY=";
        };
      });
    })
  ];
}
