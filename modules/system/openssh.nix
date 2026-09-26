{ self, config, ... }:
let
  inherit (self.lib.site.network) sshPort;
  nixosHosts = builtins.attrNames config.configurations.nixos;
in
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
          { name = "opnsense"; }
        ]
        ++ map (name: {
          inherit name;
          port = sshPort;
        }) nixosHosts;
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
            opnsense.HostName = "opnsense";
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
          }
          // lib.genAttrs nixosHosts (name: {
            HostName = name;
            Port = sshPort;
          });
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
          ports = [ sshPort ];
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
