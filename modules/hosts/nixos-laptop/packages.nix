{
  configurations.nixos.nixos-laptop.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            kdePackages.neochat
            rssguard
          ];
        };
    };
}
