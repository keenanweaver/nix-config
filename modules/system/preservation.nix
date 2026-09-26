{ inputs, ... }:
{
  flake.modules.nixos.profile-base =
    { ... }:
    {
      imports = [
        inputs.preservation.nixosModules.default
      ];
      fileSystems."/persist".neededForBoot = true;
      nix.settings.build-dir = "/nix/build";
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
              file = "/var/lib/systemd/random-seed";
              how = "symlink";
            }
          ];
        };
      };
      systemd = {
        services.systemd-machine-id-commit = {
          serviceConfig.ExecStart = [
            ""
            "systemd-machine-id-setup --commit --root /persist"
          ];
          unitConfig.ConditionPathIsMountPoint = [
            ""
            "/persist/etc/machine-id"
          ];
        };
        suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
        tmpfiles.rules = [ "d /nix/build 0755 root root -" ];
      };
    };
  flake-file.inputs.preservation.url = "github:nix-community/preservation";
}
