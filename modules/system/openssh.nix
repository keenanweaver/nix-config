{
  flake.modules = {
    homeManager.base-profile =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          lazyssh
          sshs
        ];
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
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
            regretpi = {
              HostName = "regretpi";
              Port = 22;
            };
            remorsepi = {
              HostName = "remorsepi";
              Port = 22;
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
      };
    nixos.base-profile =
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
            AllowUsers = [ "${config.my.user}" ];
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };
      };
  };
}
