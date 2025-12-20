{
  lib,
  username,
  pkgs,
  inputs,
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
    kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    kernelParams = [
      "amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
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
      # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
      extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
      extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    };
  };

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
  ];

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
                 activated = "${lib.getExe pkgs.libnotify} LACT \"Gaming profile activated\" -i io.github.ilya_zlobintsev.LACT -a LACT";
                 deactivated = "${lib.getExe pkgs.libnotify} LACT \"Default profile activated\" -i io.github.ilya_zlobintsev.LACT -a LACT";
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
                if [ "$total_ram" -lt 6000000 ]; then
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
            enable = true;
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
