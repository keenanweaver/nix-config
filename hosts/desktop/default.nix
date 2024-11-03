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
  gsr.defaultAudioDevice = "alsa_output.usb-Schiit_Audio_Schiit_Modi_-00.analog-stereo.monitor";

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
  };

  environment = {
    sessionVariables = {
      # Prefer gaming cache on 7950X3D. Also use `taskset 00FF00FF %command%` for Proton games
      # https://github.com/ValveSoftware/Proton/issues/7154
      WINE_CPU_TOPOLOGY = "8:0,1,2,3,4,5,6,7";
    };
  };

  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    hostName = "nixos-desktop";
    wireless.enable = false;
  };

  programs = {
    gamemode = {
      settings = {
        cpu = {
          park_cores = "16-31";
        };
      };
    };
  };

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
          "10-clock-allowed-rates" = {
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
                    "target.object" = "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo";
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

    # TODO: Remove when Linux 6.13 is out: https://www.phoronix.com/news/AMDGPU-More-Aggressive-Power
    udev = {
      extraRules = ''
        # https://reddit.com/r/linux_gaming/comments/196tz6v/psa_amdgpu_power_management_may_fix_your/khxs3q3/?context=3 https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_825883
        # https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_1854170
        KERNEL=="card1", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
      '';
    };
  };

  # https://discourse.nixos.org/t/how-to-properly-turn-off-wifi-on-boot-or-before-shutdown-or-reboot-in-nixos/38712/4
  systemd.services."disable-wifi-on-boot" = {
    restartIfChanged = false;
    description = "Disable wifi on boot via nmcli";
    after = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi off";
      Type = "oneshot";
      RemainAfterExit = "true";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  home-manager.users.${username} = { };
}
