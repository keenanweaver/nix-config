{
  inputs,
  lib,
  username,
  modulesPath,
  config,
  ...
}:
let
  basic-config =
    { }:
    {
      raspberry-pi-nix.board = "bcm2711";
      hardware = {
        bluetooth.enable = lib.mkForce true;
        raspberry-pi = {
          config = {
            cm4 = {
              options = {
                otg_mode = {
                  enable = true;
                  value = true;
                };
              };
            };
            pi4 = {
              options = {
                arm_boost = {
                  enable = true;
                  value = true;
                };
              };
              dt-overlays = {
                vc4-kms-v3d = {
                  enable = true;
                  params = {
                    cma-512 = {
                      enable = true;
                    };
                  };
                };
              };
            };
            all = {
              options = {
                # The firmware will start our u-boot binary rather than a
                # linux kernel.
                kernel = {
                  enable = true;
                  value = "u-boot-rpi-arm64.bin";
                };
                arm_64bit = {
                  enable = true;
                  value = true;
                };
                enable_uart = {
                  enable = true;
                  value = true;
                };
                avoid_warnings = {
                  enable = true;
                  value = true;
                };
                camera_auto_detect = {
                  enable = true;
                  value = true;
                };
                display_auto_detect = {
                  enable = true;
                  value = true;
                };
                disable_overscan = {
                  enable = true;
                  value = true;
                };
              };
              dt-overlays = {
                vc4-kms-v3d = {
                  enable = true;
                  params = { };
                };
              };
              base-dt-params = {
                krnbt = {
                  enable = true;
                  value = "on";
                };
                spi = {
                  enable = true;
                  value = "on";
                };
              };
            };
          };
        };
      };
    };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # System
    ./impermanence.nix
    # Profiles
    ../../modules
    # Raspberry Pi
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    basic-config
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
    hostName = "remorse";
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "10.20.1.95";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.20.1.1";
      interface = "end0";
    };
    nameservers = [ "10.20.1.1" ];
    wireless.enable = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services = {
    cockpit = {
      enable = true;
      openFirewall = true;
    };
    /*
      homearr = {
         enable = true;
       };
    */
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
    home-assistant = {
      enable = true;
      extraComponents = [
        "default_config"
        "openweathermap"
      ];
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

  /*
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
  */

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ lgogdownloader ];
    };
}
