{
  lib,
  username,
  pkgs,
  ...
}:
{
  imports = [
    # System
    ./disko.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
    # Plasma
    ../../modules/desktop-environments/kde/plasma-manager/desktop.nix
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;
  solaar.enable = true;
  streamcontroller.enable = true;
  vhs-decode.enable = false;

  boot = {
    initrd = {
      availableKernelModules = lib.mkDefault [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = lib.mkDefault [
      "dm-snapshot"
      "kvm-amd"
      "tcp_bbr"
      "uinput"
    ];
    kernelPackages = pkgs.linuxPackages_cachyos-gcc.cachyOverride { mArch = "ZEN4"; };
    kernelParams = lib.mkDefault [
      "amd_iommu=on"
      "amd_pstate=active"
      "microcode.amd_sha_check=off"
    ];
    loader = {
      limine = {
        extraEntries =
          let
            windowspartuuid = "360eceef-be4b-4477-8d89-af08b7edb5c8";
          in
          ''
            /+Windows
            //Windows 11 IoT Enterprise LTSC
                protocol: efi
                path: uuid(${windowspartuuid}):/EFI/Microsoft/Boot/bootmgfw.efi
          '';
        style.interface.resolution = "2560x1440";
      };
    };
    tmp.tmpfsSize = "100%";
  };

  hardware = {
    amdgpu = {
      initrd.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    hostName = "nixos-desktop";
  };

  nix.settings.build-dir = "/nix/build";

  powerManagement.cpuFreqGovernor = "ondemand";

  services = {
    /*
      lact = {
         settings = {
           version = 5;
           daemon = {
             log_level = "info";
             admin_group = "wheel";
             disable_clocks_cleanup = false;
           };
           apply_settings_timer = 5;
           profiles = {
             # Idea from https://gitlab.freedesktop.org/drm/amd/-/issues/3618#note_2981844
             gaming = {
               gpus = {
                 "1002:744C-1EAE:7901-0000:03:00.0" = {
                   fan_control_enabled = false;
                   pwfw_options = {
                     zero_rpm = true;
                   };
                   performance_level = "high";
                 };
               };
               rule = {
                 type = "process";
                 filter = {
                   name = "winedevice.exe";
                 };
               };
               hooks = {
                 activated = "${pkgs.libnotify}/bin/notify-send LACT \"Gaming profile activated\" -i io.github.ilya_zlobintsev.LACT -a LACT";
                 deactivated = "${pkgs.libnotify}/bin/notify-send LACT \"Default profile activated\" -i io.github.ilya_zlobintsev.LACT -a LACT";
               };
             };
           };
           auto_switch_profiles = true;
         };
       };
    */
    pipewire = {
      extraConfig = {
        pipewire = {
          "10-clock-rate" = {
            "context.properties" = {
              # To make DAC properly work
              "default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
              "default.clock.quantum" = 256;
              "default.clock.min-quantum" = 256;
              "default.clock.max-quantum" = 256;
            };
          };
          # Create mono-only microphone output
          "10-loopback-mono-mic" = {
            "context.modules" = [
              {
                "name" = "libpipewire-module-loopback";
                "args" = {
                  "node.description" = "Samson G-Track Pro [MONO]";
                  "capture.props" = {
                    "node.name" = "capture.mono-microphone";
                    "audio.position" = [ "FL" ];
                    "target.object" =
                      "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo";
                    "stream.dont-remix" = true;
                    "node.passive" = true;
                  };
                  "playback.props" = {
                    "media.class" = "Audio/Source";
                    "node.name" = "mono-microphone";
                    "audio.position" = [ "MONO" ];
                  };
                };
              }
            ];
          };
        };
      };
    };
    ucodenix = {
      enable = true;
      cpuModelId = "00A60F12";
    };
    zram-generator = {
      enable = true;
      settings = {
        zram0 = {
          compression-algorithm = "zstd";
          zram-size = "ram";
        };
      };
    };
  };

  systemd = {
    services = {
      # NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
      plymouth-quit-wait.enable = false;
    };
    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  home-manager.users.${username} = {
    home = {
      sessionVariables = {
        WAYLANDDRV_PRIMARY_MONITOR = "DP-1"; # https://reddit.com/r/linux_gaming/comments/1louxm2/fix_for_wine_wayland_using_wrong_monitor/
        WINE_CPU_TOPOLOGY = "16:0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
      };
    };
  };
}
