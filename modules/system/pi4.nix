{
  self,
  inputs,
  config,
  ...
}:
{
  caches.raspberrypi = {
    key = "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=";
    url = "https://nixos-raspberrypi.cachix.org";
  };
  flake.modules.nixos.pi4 =
    { lib, pkgs, ... }:
    let
      inherit (inputs) nixos-raspberrypi;
    in
    {
      imports = [
        nixos-raspberrypi.lib.inject-overlays
      ]
      ++ (with nixos-raspberrypi.nixosModules; [
        trusted-nix-caches
        raspberry-pi-4.base
        sd-image
      ]);
      _module.args = { inherit nixos-raspberrypi; };
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
      host.lanInterface = lib.mkDefault "end0";
      networking.wireless.enable = lib.mkForce false;
      nix.settings = self.lib.mkCacheSettings [ config.caches.raspberrypi ];
      nix-mineral.filesystems.normal."/boot".enable = false;
      system.boot.loader.kernelFile = "Image";
      zramSwap.enable = true;
    };
  flake-file.inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
}
