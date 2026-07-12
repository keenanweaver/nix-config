{ self, ... }:
{

  configurations.nixos.remorse.module = { config, lib, ... }: {
    imports = with self.modules.nixos; [
      self.diskoConfigurations.remorse

      base-profile
      pi-profile
    ];
    fileSystems."/" = {
      options = [ "noatime" ];
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    home-manager.users.${config.my.user} = { pkgs, ... }: {
      imports = with self.modules.homeManager; [
        base-profile
        pi-profile
      ];

      home.packages = with pkgs; [ lgogdownloader ];

      nps.stacks = {
        homeassistant.enable = true;
      };

    };
    #hardware.facter.reportPath = ./facter.json;
    networking = {
      defaultGateway = {
        address = "10.20.20.1";
        interface = "end0";
      };
      hostName = "remorse";
      interfaces.end0 = {
        ipv4.addresses = [
          {
            address = "10.20.20.30";
            prefixLength = 24;
          }
        ];
      };
      nameservers = [ "10.20.20.1" ];
      wireless.enable = false;
    };
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    services = {
      cockpit = {
        enable = true;
        openFirewall = true;
      };
      freshrss = {
        enable = true;
        passwordFile = config.sops.secrets.unraid.ntfy.password.path;
      };
      netdata = {
        enable = true;
      };
      ntfy-sh = {
        enable = true;
      };
      uptime-kuma = {
        enable = true;
      };
    };
    system.stateVersion = "26.05";
  };
}
