{
  lib,
  username,
  modulesPath,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # System
    ./impermanence.nix
    # Profiles
    ../../modules
  ];

  # Custom modules
  server.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
      ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [ ];

  networking = {
    hostName = "remorsepi";
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "10.20.20.30";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.20.20.1";
      interface = "end0";
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
    /*
      # Relies on https://github.com/NixOS/nixpkgs/pull/353616
      fusion = {
         enable = true;
       };
    */
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

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ lgogdownloader ];
      virtualization.quadlet.containers = {
        home-assistant = {
          containerConfig = {
            image = "ghcr.io/home-assistant/home-assistant:stable";
            environments = {
              TZ = "America/Chicago";
            };
            volumes = [
              "${config.xdg.configHome}/home-assistant:/config"
              "/etc/localtime:/etc/localtime:ro"
              "/run/dbus:/run/dbus:ro"
            ];
            networks = [
              "host"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };
      };
    };
}
