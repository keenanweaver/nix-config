{
  flake.modules = {
    homeManager.base-profile = { pkgs, ... }: {
      home.packages = with pkgs; [
        lazyssh
        sshs
      ];
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            addKeysToAgent = "no";
          };
          bazzite = {
            hostname = "bazzite";
            user = "bazzite";
          };
          mister = {
            hostname = "mister";
            user = "root";
          };
          mumble = {
            hostname = "game-central.party";
            port = 6777;
          };
          nix-unraid = {
            hostname = "nix-unraid";
            port = 22;
          };
          nixos-desktop = {
            hostname = "nixos-desktop";
            port = 6777;
          };
          nixos-htpc = {
            hostname = "nixos-htpc";
            port = 6777;
          };
          nixos-laptop = {
            hostname = "nixos-laptop";
            port = 6777;
          };
          opnsense = {
            hostname = "opnsense";
          };
          regretpi = {
            hostname = "regretpi";
            port = 22;
          };
          remorsepi = {
            hostname = "remorsepi";
            port = 22;
          };
          unifi-CKG2 = {
            hostname = "unifi";
            port = 6777;
            user = "keenanweaver";
          };
          unraid = {
            hostname = "crusader";
            port = 6777;
            user = "root";
          };
        };
      };
    };
    nixos.base-profile = { config, ... }: {
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
