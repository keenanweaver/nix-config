{ self, ... }:
{
  flake.modules = {
    homeManager.profile-pi.imports = with self.modules.homeManager; [
      profile-server
    ];
    nixos.profile-pi =
      {
        self,
        lib,
        config,
        ...
      }:
      let
        hostKeyDir = /tmp/extra-files + "/${config.networking.hostName}/persist/etc/ssh";
      in
      {
        imports = with self.modules.nixos; [
          profile-server
        ];
        boot = {
          consoleLogLevel = lib.mkForce 7;
          growPartition = lib.mkForce true;
          initrd.verbose = lib.mkForce true;
          loader = {
            efi.canTouchEfiVariables = lib.mkForce false;
            limine = {
              enable = lib.mkForce false;
              additionalFiles = lib.mkForce { };
              extraEntries = lib.mkForce "";
            };
          };
          supportedFilesystems.zfs = lib.mkForce false;
          zswap.enable = lib.mkForce false;
        };
        fileSystems."/".autoResize = lib.mkForce true;
        fileSystems."/persist" = {
          device = "/persist";
          fsType = "none";
          neededForBoot = true;
          options = [ "bind" ];
        };
        hardware = {
          deviceTree.enable = lib.mkForce false;
          raspberry-pi.config.all.dt-overlays.vc4-kms-v3d.enable = lib.mkForce false;
        };
        networking.hostId = lib.mkForce "8425e349";
        nix.settings = {
          extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };
        nix-mineral.filesystems.normal."/boot".enable = lib.mkForce false;
        nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
        sdImage.populateRootCommands = ''
          install -Dm600 ${hostKeyDir}/ssh_host_ed25519_key ./files/persist/etc/ssh/ssh_host_ed25519_key
          install -Dm644 ${hostKeyDir}/ssh_host_ed25519_key.pub ./files/persist/etc/ssh/ssh_host_ed25519_key.pub
        '';
        services.btrfs.autoScrub.enable = lib.mkForce false;
        system.boot.loader.kernelFile = lib.mkForce "Image";
      };
  };
  flake-file.inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
}
