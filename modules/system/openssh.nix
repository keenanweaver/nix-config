{
  flake.modules = {
    homeManager.profile-base =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        mkHostBlock =
          {
            name,
            port ? null,
            user ? null,
          }:
          ''
            Host ${name}-ts
              HostName ${name}.${tailnetDns}
          ''
          + lib.optionalString (user != null) "  User ${user}\n"
          + lib.optionalString (port != null) "  Port ${toString port}\n";
        tailnetDns = config.sops.placeholder."tailscale/tailnet_dns";
        tailscaleHosts = [
          {
            name = "mister";
            user = "root";
          }
          {
            name = "crusader";
            user = "root";
          }
          {
            name = "nixos-desktop";
            port = 6777;
          }
          {
            name = "nixos-htpc";
            port = 6777;
          }
          {
            name = "nixos-laptop";
            port = 6777;
          }
          {
            name = "regret";
            port = 6777;
          }
          {
            name = "remorse";
            port = 6777;
          }
          { name = "opnsense"; }
        ];
      in
      {
        home.packages = with pkgs; [
          lazyssh
          sshs
        ];
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          includes = [ config.sops.templates."ssh-tailscale.conf".path ];
          settings = {
            "*".addKeysToAgent = "yes";
            bazzite = {
              HostName = "bazzite";
              User = "bazzite";
            };
            "codeberg.org" = {
              identitiesOnly = true;
              identityFile = "~/.ssh/id_ed25519";
            };
            "github.com" = {
              identitiesOnly = true;
              identityFile = "~/.ssh/id_ed25519";
            };
            mister = {
              HostName = "mister";
              User = "root";
            };
            mumble = {
              HostName = "game-central.party";
              Port = 6777;
            };
            nix-unraid = {
              HostName = "nix-unraid";
              Port = 22;
            };
            nixos-desktop = {
              HostName = "nixos-desktop";
              Port = 6777;
            };
            nixos-htpc = {
              HostName = "nixos-htpc";
              Port = 6777;
            };
            nixos-laptop = {
              HostName = "nixos-laptop";
              Port = 6777;
            };
            opnsense.HostName = "opnsense";
            regret = {
              HostName = "regret";
              Port = 6777;
            };
            remorse = {
              HostName = "remorse";
              Port = 6777;
            };
            "tangled.org" = {
              identitiesOnly = true;
              identityFile = "~/.ssh/id_ed25519";
            };
            unifi-CKG2 = {
              HostName = "unifi";
              Port = 6777;
              User = "keenanweaver";
            };
            unraid = {
              HostName = "crusader";
              Port = 6777;
              User = "root";
            };
          };
        };
        services.ssh-agent.enable = true;
        sops = {
          secrets."tailscale/tailnet_dns" = { };
          templates."ssh-tailscale.conf".content = lib.concatMapStrings mkHostBlock tailscaleHosts;
        };
      };
    nixos.profile-base =
      { config, ... }:
      {
        services.openssh = {
          enable = true;
          hostKeys = [
            {
              path = "/persist/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];
          ports = [ 6777 ];
          settings = {
            AllowUsers = [ config.my.user ];
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };
      };
  };
}
