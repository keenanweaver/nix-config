{
  configurations.nixos.nixos-htpc.module =
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.slippi.nixosModules.default
      ];
      home-manager.users.${config.my.user} =
        { inputs, config, ... }:
        {
          imports = [
            inputs.slippi.homeManagerModules.default
          ];
          home.packages = with pkgs; [
            #banjorecomp
            clonehero
            dusklight
            jazz2
            local.sonic3air
            moon-child-fe
            openomf
            pegasus-frontend
            sdlpop
            shadps4-qtlauncher
            sm64ex
            wipeout-rewrite
            yarg
            zelda64recomp
          ];
          services.flatpak.packages = [
            "net.retrodeck.retrodeck"
          ];
          slippi-launcher = {
            enable = true;
            isoPath = "${config.home.homeDirectory}/Games/retrodeck/roms/gc/Super Smash Bros. Melee (USA) (En,Ja) (Rev 2).rvz";
            rootSlpPath = "${config.home.homeDirectory}/Games/slippi";
          };
        };
      nix.settings = {
        extra-substituters = [ "https://slippi-nix.cachix.org" ];
        extra-trusted-public-keys = [
          "slippi-nix.cachix.org-1:2qnPHiOxTRpzgLEtx6K4kXq/ySDg7zHEJ58J6xNDvBo="
        ];
      };
      programs = {
        #ghostship.enable = true;
        shipwright-git.enable = true;
        sm64coopdx = {
          enable = true;
          coopNet.openFirewall = true;
        };

        #spaghetti-kart-git.enable = true;
        #starship-sf64.enable = true;
      };
    };
  flake-file.inputs.slippi = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:lytedev/slippi-nix";
  };
}
