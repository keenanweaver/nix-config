{
  configurations.nixos.nixos-htpc.module =
    { lib, pkgs, ... }:
    {
      boot.plymouth = {
        theme = lib.mkForce "steamos";
        themePackages = [ pkgs.local.plymouth-theme-steamos ];
      };
    };
}
