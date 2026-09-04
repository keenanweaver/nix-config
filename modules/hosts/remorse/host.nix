{ self, ... }:
{

  configurations.nixos.remorse.module =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports =
        with self.modules.nixos;
        [
          profile-base
          profile-pi
        ]
        ++ (with inputs.nixos-raspberrypi.nixosModules; [
          inputs.nixos-raspberrypi.lib.inject-overlays
          trusted-nix-caches
          raspberry-pi-4.base
          sd-image
        ]);
      boot.kernelPackages =
        lib.mkForce
          inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi4;
      home-manager.users.${config.my.user} =
        { config, pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            profile-base
            profile-pi
          ];
          home.packages = with pkgs; [ local.lgogdownloader ];
          nps = {
            externalStorageBaseDir = "${config.home.homeDirectory}/external";
            hostIP4Address = "10.20.20.30";
            stacks = {
              freshrss.enable = true;
              homeassistant.enable = true;
              homepage.enable = true;
            };
          };
        };
      networking = {
        defaultGateway = {
          address = "10.20.20.1";
          interface = "end0";
        };
        hostName = "remorse";
        interfaces.end0.ipv4.addresses = [
          {
            address = "10.20.20.30";
            prefixLength = 24;
          }
        ];
        nameservers = [ "10.20.20.1" ];
        wireless.enable = lib.mkForce false;
      };
      system.stateVersion = "26.05";
    };
}
