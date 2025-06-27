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
  streamcontroller.enable = true;
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
      "microcode.amd_sha_check=off"
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

  powerManagement.cpuFreqGovernor = "schedutil";

  services = {
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

  zramSwap = {
    enable = true;
  };

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ solaar ];
        sessionVariables = {
          WINE_CPU_TOPOLOGY = "16:0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
        };
      };
    };
}
