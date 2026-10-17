{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.profile-base = {
      home.language = {
        base = "en_US.UTF-8";
        collate = "C.UTF-8";
      };
      xdg.enable = true;
    };
    nixos.profile-base =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        imports = with self.modules.nixos; [
          local-packages
        ];
        console.earlySetup = true;
        environment = {
          etc.motd.text =
            let
              d = inputs.nixpkgs.lastModifiedDate;
              nixpkgsDate = "${part 0 4}-${part 4 2}-${part 6 2} ${part 8 2}:${part 10 2}:${part 12 2} UTC";
              part = start: len: lib.substring start len d;
            in
            ''
              NixOS release: ${config.system.nixos.release}
              Nixpkgs revision: ${inputs.nixpkgs.rev} (${nixpkgsDate})
            '';
          localBinInPath = true;
          shells = with pkgs; [
            bash
            zsh
          ];
        };
        home-manager.sharedModules = [ self.modules.homeManager.profile-base ];
        services = {
          earlyoom = {
            enable = true;
            freeMemThreshold = 5;
          };
          journald.settings.Journal.SystemMaxUse = "50M";
        };
        systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
        time.timeZone = "America/Chicago";
        users.motdFile = "/etc/motd";
      };
  };
  flake-file.description = "Keenan's NixOS configuration";
}
