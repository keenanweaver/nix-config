{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.profile-base =
      {
        lib,
        config,
        osConfig,
        ...
      }:
      {
        home = {
          language = {
            base = "en_US.UTF-8";
            collate = "C.UTF-8";
          };
          shellAliases = {
            b = "bat --color=always -pp";
            bb = "bat --color=always";
            imp = "lsd --one-file-system --base-directory / -t f -H -E '{tmp,etc/passwd,var/lib/systemd/coredump}'"; # https://reddit.com/r/NixOS/comments/1nhm4mm/tailscale_impermanence_broken/nedm0vd/?context=3#nedm0vd
            j = "just --justfile $NH_FLAKE/Justfile";
            l = "lsd -la --group-dirs=first";
            ngc = "nh clean all";
            nor = "nh os boot";
            upd = "topgrade";
            wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
          }
          // lib.optionalAttrs osConfig.virtualisation.podman.enable {
            rbn = "podman stop -a && systemctl reboot";
          };
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
        users = {
          defaultUserShell = pkgs.zsh;
          motdFile = "/etc/motd";
          mutableUsers = false;
        };
      };
  };
  flake-file.description = "Keenan's NixOS configuration";
}
