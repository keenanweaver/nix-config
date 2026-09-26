{ self, inputs, ... }:
{
  configurations.nixos.nixos-htpc.module =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.slippi-nix.nixosModules.default
      ];
      home-manager.users.${config.my.user} =
        { config, ... }:
        {
          imports = [
            inputs.slippi-nix.homeManagerModules.default
          ];
          home.packages = with pkgs; [
            banjorecomp
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
            vvvvvv
            wipeout-rewrite
            yarg
            zelda64recomp
          ];
          services.flatpak.packages = [
            "dev.eden_emu.eden"
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
      system.extraDependencies =
        with self.lib.roms;
        self.lib.pinRoms pkgs [
          banjo
          mm
          sm64
        ];
    };
  flake-file.inputs.slippi-nix = {
    inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:lytedev/slippi-nix";
  };
}
