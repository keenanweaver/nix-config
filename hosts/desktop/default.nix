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
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = [
      "dm-snapshot"
      "kvm-amd"
      "tcp_bbr"
    ];
    kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
    kernelParams = [
      #"amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
      "amd_iommu=on"
      "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
      "amdgpu.mcbp=0"
      "microcode.amd_sha_check=off"
      # AMDGPU freezing randomly https://gitlab.freedesktop.org/drm/amd/-/issues/4141
      # https://gitlab.freedesktop.org/mesa/mesa/-/issues/14250#note_3181015
      # https://reddit.com/r/linux_gaming/comments/1q1bg71/8_threads_in_2_weeks_amd_gpus_crashing_on/nx5zixu/?context=3#nx5zixu
      # Run 'sudo cat /sys/kernel/debug/dri/128/amdgpu_gpu_recover' to fix
      "amdgpu.runpm=0"
      "amdgpu.dcdebugmask=0x10"
      "amdgpu.aspm=0"
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
    kernel.sysctl = {
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
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

  nix = {
    settings = {
      build-dir = "/nix/build";
      extra-substituters = [
        "https://attic.xuyh0120.win/lantian" # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
        "https://nix-cache.tokidoki.dev/tokidoki"
      ];
      extra-trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
      ];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  services = {
    lact = {
      settings = {
        version = 5;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus = {
          # Undervolted
          "1002:744C-1EAE:7901-0000:03:00.0" = {
            fan_control_enabled = false;
            pwfw_options = {
              zero_rpm = true;
            };
            performance_level = "auto";
            power_cap = 305.0;
            voltage_offset = -50;
          };
        };
        profiles = {
          # Idea from https://gitlab.freedesktop.org/drm/amd/-/issues/3618#note_2981844
          Gaming = {
            gpus = {
              "1002:744C-1EAE:7901-0000:03:00.0" = {
                fan_control_enabled = false;
                pwfw_options = {
                  zero_rpm = true;
                };
                performance_level = "high";
                # Alternative setup:
                # performance_level = "manual";
                # power_profile_mode_index = 1;
              };
            };
            rule = {
              type = "process";
              filter = {
                name = "winedevice.exe";
              };
            };
          };
        };
        auto_switch_profiles = true;
      };
    };
    pipewire = {
      extraConfig = {
        pipewire = {
          "10-clock" = {
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
              # https://reddit.com/r/linux_gaming/comments/1gy347h/newbie_here_ive_tried_almost_all_fixes_theres/lylqijj/?context=3#lylqijj
              "default.clock.quantum" = 256;
              "default.clock.min-quantum" = 256;
              "default.clock.max-quantum" = 256;
              "default.clock.quantum-limit" = 256;
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
        # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/systemd/zram-generator.conf
        zram0 = {
          compression-algorithm = "zstd lz4 (type=huge)";
          zram-size = "ram";
          swap-priority = 180;
          fs-type = "swap";
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
    user.services = {
      check-ram-on-boot = {
        description = "Check if all RAM is loaded on boot";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            with pkgs;
            lib.getExe (writeShellApplication {
              name = "check-ram-on-boot";
              runtimeInputs = [
                coreutils
                kdePackages.kdialog
                ripgrep
                systemd
              ];
              text = ''
                total_ram=$(rg MemTotal /proc/meminfo | tr -s ' ' | cut -d ' ' -f2)
                if [ "$total_ram" -lt 60000000 ]; then
                  if kdialog --title "RAM Issue" \
                    --warningyesno "Not all RAM loaded. Mobo messed up again.\n\nReboot now?"; then
                    systemctl reboot
                  fi
                fi
              '';
            });
          RemainAfterExit = false;
        };
      };
    };
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      home = {
        file = {
          dxvk-conf = {
            enable = false;
            text = ''
              d3d9.maxFrameRate = 357
              dxgi.maxFrameRate = 357
              dxgi.syncInterval = 0
              dxvk.tearFree = True
            '';
            target = "${config.xdg.configHome}/dxvk/dxvk.conf";
          };
        };
        packages = with pkgs; [
          amdgpu_top
          nvtopPackages.amd
        ];
        sessionVariables = {
          DXVK_CONFIG_FILE = "${config.xdg.configHome}/dxvk/dxvk.conf";
          WAYLANDDRV_PRIMARY_MONITOR = "DP-1"; # https://reddit.com/r/linux_gaming/comments/1louxm2/fix_for_wine_wayland_using_wrong_monitor/
          WINE_CPU_TOPOLOGY = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
        };
      };
    };
}
