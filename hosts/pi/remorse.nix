{
  lib,
  username,
  modulesPath,
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
    device = "/dev/disk/by-label/NIXOS_SD"; # this is important!
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [ ];

  networking = {
    hostName = "remorse";
    wireless.enable = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services = {
    cockpit = {
      enable = true;
      openFirewall = true;
    };
    homearr = {
      enable = true;
    };
    home-assistant = {
      enable = true;
      openFirewall = true;
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

  virtualisation = {
    oci-containers = {
      containers = {
        flare-solvarr = {
          image = "ghcr.io/flaresolverr/flaresolverr:latest";
          autoStart = true;
          ports = [ "127.0.0.1:8191:8191" ];
          environment = {
            LOG_LEVEL = "info";
            LOG_HTML = "false";
            CAPTCHA_SOLVER = "hcaptcha-solver";
            TZ = "America/Chicago";
          };
        };
        homarr = {
          image = "ghcr.io/ajnart/homarr:latest";
          ports = [ "7575:7575" ];
          volumes = [
            "./homarr/data:/data"
            "./homarr/configs:/app/data/configs"
            "./homarr/icons:/app/public/icons"
          ];
        };
      };
    };
  };

  home-manager.users.${username} = {

  };
}
