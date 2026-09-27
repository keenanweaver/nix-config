{
  configurations.nixos.nixos-htpc.module =
    { pkgs, ... }:
    {
      boot.plymouth = {
        theme = "steamos";
        themePackages = [ pkgs.local.plymouth-theme-steamos ];
      };
    };
}
