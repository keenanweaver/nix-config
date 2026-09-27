{
  flake.modules.nixos.profile-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      hardware.i2c.enable = lib.mkDefault true;
      services.hardware.openrgb = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.openrgb-with-all-plugins;
      };
      users.users.${config.my.user}.extraGroups = [
        "i2c"
      ];
    };
}
