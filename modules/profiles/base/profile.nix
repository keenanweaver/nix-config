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
              nixpkgsDate = lib.removeSuffix "\n" (
                builtins.readFile (
                  pkgs.runCommand "nixpkgs-date" { } ''
                    TZDIR=${pkgs.tzdata}/share/zoneinfo TZ=${config.time.timeZone} \
                      date -d @${toString inputs.nixpkgs.lastModified} +'%Y-%m-%d %H:%M:%S %Z' > "$out"
                  ''
                )
              );
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
