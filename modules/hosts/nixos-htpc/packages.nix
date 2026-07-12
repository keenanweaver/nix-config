{
  configurations.nixos.nixos-htpc.module = { config, pkgs, ... }: {
    home-manager.users.${config.my.user} = {
      home.packages = with pkgs; [
        dusklight
        openomf
        pegasus-frontend
        shadps4
        local.sonic3air
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
