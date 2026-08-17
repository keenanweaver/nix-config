{
  flake.modules.nixos.gaming-profile =
    { config, pkgs, ... }:
    {
      hardware.i2c.enable = true;
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
      };
      users.users.${config.my.user}.extraGroups = [
        "i2c"
      ];
    };
}
