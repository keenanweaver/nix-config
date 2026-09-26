{ self, config, ... }:
{
  configurations.nixos.nixos-desktop.module.nix.settings = self.lib.mkCacheSettings (
    with config.caches;
    [
      noctalia
      raspberrypi
    ]
  );
}
