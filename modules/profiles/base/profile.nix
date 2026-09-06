{ self, ... }:
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
        inputs,
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
          etc.motd.text = ''
            NixOS release: ${config.system.nixos.release}
            Nixpkgs revision: ${inputs.nixpkgs.rev}
          '';
          localBinInPath = true;
          shells = with pkgs; [
            bash
            zsh
          ];
        };
        i18n.defaultLocale = "en_US.UTF-8";
        programs.iotop.enable = true;
        services = {
          earlyoom = {
            enable = true;
            freeMemThreshold = 5;
          };
          journald.settings.Journal.SystemMaxUse = "50M";
          logrotate.enable = true;
        };
        systemd.settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
        };
        time.timeZone = "America/Chicago";
        users.motdFile = "/etc/motd";
      };
  };
  flake-file.description = "Keenan's NixOS configuration";
}
