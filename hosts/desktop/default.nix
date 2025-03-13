{
  lib,
  username,
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
  gsr.defaultAudioDevice = "alsa_output.usb-Schiit_Audio_Schiit_Modi_-00.analog-stereo.monitor"; # alsa_output.usb-Generic_USB_Audio-00.analog-stereo.monitor
  vhs-decode.enable = true;

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
    kernelParams = lib.mkDefault [
      "amd_iommu=on"
      "amd_pstate=guided"
    ];
    loader = {
      systemd-boot = {
        windows = {
          "11" = {
            title = "Windows 11";
            efiDeviceHandle = "HD3b";
            sortKey = "z_windows";
          };
        };
      };
    };
    tmp.tmpfsSize = "100%";
  };

  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    hostName = "nixos-desktop";
    wireless.enable = false;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  services = {
    beesd = {
      filesystems = {
        games = {
          spec = "/home/${username}/Games";
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "5.0"
          ];
        };
      };
    };
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
              "default.clock.quantum" = 512;
              "default.clock.min-quantum" = 512;
              "default.clock.max-quantum" = 512;
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
  };

  systemd.targets = {
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  zramSwap = {
    enable = true;
  };

  home-manager.users.${username} = { };
}
