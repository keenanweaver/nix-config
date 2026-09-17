{
  flake.modules.nixos.profile-base.nixpkgs.overlays = [
    (_final: prev: {
      buildGo125Module = prev.buildGoModule;
    })
  ];
}
