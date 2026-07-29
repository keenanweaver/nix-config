{
  configurations.nixos.nixos-htpc.module =
    { config, pkgs, ... }:
    {
      home-manager.users.${config.my.user} = {
        home.packages = with pkgs; [
          dusklight
          local.sonic3air
          openomf
          pegasus-frontend
          shadps4-qtlauncher
          wipeout-rewrite
          zelda64recomp
        ];

        services.flatpak.packages = [
          "net.retrodeck.retrodeck"
        ];
      };

      programs = {
        shipwright-git.enable = true;

        sm64coopdx = {
          enable = true;
          coopNet.openFirewall = true;
        };

        spaghetti-kart-git.enable = true;
        starship-sf64.enable = true;
      };
    };
}
