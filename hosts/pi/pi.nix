{
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{

  imports = [
    # System
    #./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
    # Raspberry Pi
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # Custom modules
  server.enable = true;
  # Apps
  btop.enable = lib.mkForce false;
  direnv.enable = lib.mkForce false;
  helix.enable = lib.mkForce false;
  jujutsu.enable = lib.mkForce false;
  nvim.enable = lib.mkForce false;
  virtualization.enable = lib.mkForce false;
  # System
  flatpak.enable = lib.mkForce false;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
      ];
    };
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    loader.systemd-boot.enable = lib.mkForce false;
    supportedFilesystems = lib.mkForce [
      "vfat"
      "btrfs"
      "tmpfs"
    ];
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  hardware = {
    bluetooth = {
      enable = lib.mkForce true;
      powerOnBoot = true;
    };
    deviceTree = {
      filter = "bcm2711-rpi-4*.dtb";
      overlays = [
        {
          name = "bluetooth-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
                compatible = "brcm,bcm2711";

                fragment@0 {
                    target = <&uart0_pins>;
                    __overlay__ {
                            brcm,pins = <30 31 32 33>;
                            brcm,pull = <2 0 0 2>;
                    };
                };
            };
          '';
        }
      ];
    };
    raspberry-pi = {
      "4".fkms-3d.enable = true;
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

  networking.networkmanager.wifi.powersave = false;

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-linux";
    overlays = [
      (final: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };

  raspberry-pi-nix = {
    board = "bcm2711"; # Pi 4B
    uboot.enable = true;
  };

  services = {
    blueman.enable = true;
  };

  sdImage.compressImage = false;

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };
}
