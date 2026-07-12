{
  flake.modules.nixos.base-profile = { inputs, ... }: {
    imports = [
      inputs.preservation.nixosModules.default
    ];
    fileSystems."/persist".neededForBoot = true;
    preservation = {
      enable = true;
      preserveAt."/persist" = {
        directories = [
          "/var/db/sudo/lectured"
          "/var/lib/fail2ban"
          "/var/lib/fwupd"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/var/lib/power-profiles-daemon"
          "/var/lib/systemd"
          "/var/log"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            configureParent = true;
            file = "/etc/ssh/ssh_host_ed25519_key";
            how = "symlink";
          }
          {
            configureParent = true;
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            how = "symlink";
          }
          {
            configureParent = true;
            file = "/etc/ssh/ssh_host_rsa_key";
            how = "symlink";
          }
          {
            configureParent = true;
            file = "/etc/ssh/ssh_host_rsa_key.pub";
            how = "symlink";
          }
          {
            file = "/var/lib/systemd/random-seed";
            how = "symlink";
          }
        ];
      };
    };
    systemd.services.systemd-machine-id-commit = {
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persist"
      ];
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persist/etc/machine-id"
      ];
    };
    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  };
  flake-file.inputs = {
    preservation.url = "github:nix-community/preservation";
  };
}
