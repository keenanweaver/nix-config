{
  flake.modules.nixos.gaming-profile = { pkgs, ... }: {
    hardware.i2c.enable = true;
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}
