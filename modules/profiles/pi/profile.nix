{ self, ... }:
{
  flake.modules = {
    homeManager.profile-pi =
      { pkgs, ... }:
      {
        imports = with self.modules.homeManager; [
          profile-server
        ];
        programs = {
          devenv.enable = false;
          distrobox.enable = false;
          lazyvim.enable = false;
          nix-search-tv.enable = false;
          yazi.extraPackages = with pkgs; [
            fd
            ripgrep
            fzf
            zoxide
          ];
          yt-dlp.enable = false;
        };
      };
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
          consoleLogLevel = 7;
          growPartition = true;
          initrd.verbose = true;
          supportedFilesystems.zfs = false;
          zswap.enable = false;
        };
        fileSystems = {
          "/".autoResize = true;
          "/persist" = {
            device = "/persist";
            fsType = "none";
            neededForBoot = true;
            options = [ "bind" ];
          };
        };
        hardware = {
          deviceTree.enable = false;
          raspberry-pi.config.all.dt-overlays.vc4-kms-v3d.enable = false;
        };
        networking.hostId = "8425e349";
        nix.settings = {
          extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };
        nix-mineral.filesystems.normal."/boot".enable = false;
        nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
        sdImage.populateRootCommands = ''
          install -Dm600 ${hostKeyDir}/ssh_host_ed25519_key ./files/persist/etc/ssh/ssh_host_ed25519_key
          install -Dm644 ${hostKeyDir}/ssh_host_ed25519_key.pub ./files/persist/etc/ssh/ssh_host_ed25519_key.pub
        '';
        system.boot.loader.kernelFile = "Image";
        zramSwap.enable = true;
      };
  };
}
