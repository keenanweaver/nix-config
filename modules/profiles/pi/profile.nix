{ self, ... }:
{
  flake.modules = {
    homeManager.profile-pi =
      {
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        imports = with self.modules.homeManager; [
          profile-server
        ];
        nps = {
          externalStorageBaseDir = "${config.home.homeDirectory}/external";
          hostIP4Address = self.lib.site.network.hosts.${osConfig.networking.hostName};
        };
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
        lib,
        config,
        pkgs,
        nixos-raspberrypi,
        ...
      }:
      let
        inherit (self.lib.site) network;
      in
      {
        imports = [
          self.modules.nixos.profile-server
        ]
        ++ (with nixos-raspberrypi.nixosModules; [
          nixos-raspberrypi.lib.inject-overlays
          trusted-nix-caches
          raspberry-pi-4.base
          sd-image
        ]);
        boot = {
          consoleLogLevel = 7;
          growPartition = true;
          initrd.verbose = true;
          kernelPackages = nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi4;
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
        networking = {
          defaultGateway = {
            address = network.gateway;
            interface = "end0";
          };
          interfaces.end0.ipv4.addresses = [
            {
              address = network.hosts.${config.networking.hostName};
              prefixLength = 24;
            }
          ];
          nameservers = [ network.gateway ];
          wireless.enable = lib.mkForce false;
        };
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
        system.boot.loader.kernelFile = "Image";
        zramSwap.enable = true;
      };
  };
}
