{ config, ... }:
let
  inherit (config.site) nas network;
  inherit (network) sshPort;
  nixosHosts = builtins.attrNames config.configurations.nixos;
in
{
  flake.modules = {
    homeManager.profile-base =
      {
        lib,
        pkgs,
        osConfig,
        ...
      }:
      {
        home.packages = with pkgs; [
          lazyssh
          sshs
        ];
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          includes = [ osConfig.sops.templates."ssh-tailscale.conf".path ];
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
              Port = sshPort;
            };
            opnsense.HostName = "opnsense";
            "tangled.org" = {
              identitiesOnly = true;
              identityFile = "~/.ssh/id_ed25519";
            };
            unifi-CKG2 = {
              HostName = "unifi";
              Port = sshPort;
              User = "keenanweaver";
            };
            unraid = {
              HostName = nas.host;
              Port = sshPort;
              User = "root";
            };
          }
          // lib.genAttrs nixosHosts (name: {
            HostName = name;
            Port = sshPort;
          });
        };
        services.ssh-agent.enable = true;
      };
    nixos.profile-base =
      { lib, config, ... }:
      let
        mkHostBlock =
          {
            name,
            port ? null,
            user ? null,
          }:
          ''
            Host ${name}-ts
              HostName ${name}.${config.sops.placeholder."tailscale/tailnet_dns"}
          ''
          + lib.optionalString (user != null) "  User ${user}\n"
          + lib.optionalString (port != null) "  Port ${toString port}\n";
        tailscaleHosts = [
          {
            name = "mister";
            user = "root";
          }
          {
            name = nas.host;
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
        networking.firewall = {
          extraInputRules = "ip saddr ${network.lanSubnet} tcp dport ${toString sshPort} accept";
          interfaces.tailscale0.allowedTCPPorts = [ sshPort ];
        };
        services.openssh = {
          enable = true;
          hostKeys = [
            {
              path = "/persist/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];
          openFirewall = false;
          ports = [ sshPort ];
          settings = {
            AllowUsers = [ config.my.user ];
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };
        sops = {
          secrets."tailscale/tailnet_dns" = {
            owner = config.my.user;
            sopsFile = ../../assets/secrets/nixos.yaml;
          };
          templates."ssh-tailscale.conf" = {
            content = lib.concatMapStrings mkHostBlock tailscaleHosts;
            owner = config.my.user;
          };
        };
      };
  };
}
