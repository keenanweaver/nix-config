{
  configurations.nixos.nixos-htpc.module = {
    preservation.preserveAt."/persist".directories = [ "/var/lib/OpenRGB" ];
    services.hardware.openrgb.startupProfile = "htpc";
    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB/profiles 0755 root root -"
      "L+ /var/lib/OpenRGB/profiles/htpc.json - - - - ${../../assets/hosts/nixos-htpc/openrgb.json}"
    ];
  };
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
