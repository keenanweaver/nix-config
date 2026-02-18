{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming;
in
{
  options = {
    gaming = {
      enable = lib.mkEnableOption "Enable Gaming module in NixOS";
    };
  };

  config = lib.mkIf cfg.enable {
    # Custom modules
    apollo.enable = false;
    bottles.enable = true;
    cdemu.enable = true;
    coolercontrol.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gsr = {
      enable = true;
      ui.enable = true;
    };
    heroic.enable = true;
    lutris.enable = true;
    mangohud.enable = true;
    nero-umu.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    retroarch.enable = true;
    steam.enable = true;
    sunshine.enable = true;
    vkbasalt.enable = true;
    zerotier.enable = true;

    boot = {
      kernelModules = [
        "ntsync"
      ];
      kernelParams = [
        #"usbhid.mousepoll=8" # Reduce mouse polling rate to 125hz
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "tsc=reliable"
        "clocksource=tsc"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
      ];
      kernel = {
        sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.mmap_min_addr" = 0; # SheepShaver
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/70-cachyos-settings.conf
          "fs.file-max" = 2097152;
          "kernel.split_lock_mitigate" = 0;
          "net.core.netdev_max_backlog" = 4096;
          "net.ipv4.tcp_fin_timeout" = 5;
          "vm.dirty_background_bytes" = 67108864;
          "vm.dirty_bytes" = 268435456;
          "vm.dirty_writeback_centisecs" = 1500;
          "vm.vfs_cache_pressure" = 50;
        };
      };
    };

    drivers.mesa-git = {
      enable = true;
      enableCache = false;
      cacheCleanup = {
        enable = false;
      };
    };

    environment = {
      etc = {
        logitech-g920 = {
          text = ''
            DefaultVendor=046d
            DefaultProduct=c261
            MessageEndpoint=01
            ResponseEndpoint=01
            TargetClass=0x03
            MessageContent="0f00010142"
          '';
          target = "usb_modeswitch.d/046d:c261";
        };
      };
    };

    hardware = {
      uinput.enable = true;
      xone.enable = true;
      xpadneo.enable = true;
      yeetmouse = {
        enable = false;
      };
    };

    nix.settings = {
      extra-substituters = [
        "https://bandithedoge.cachix.org"
        "https://just-one-more-cache.cachix.org/"
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
      ];
      extra-trusted-public-keys = [
        "bandithedoge.cachix.org-1:ZtcHw1anyEa4t6H8m3o/ctYFrwYFPAwoENSvofamE6g="
        "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    programs = {
      perfect-dark-git.enable = true;
      shipwright-git.enable = true;
      sm64coopdx = {
        enable = true;
        coopNet.openFirewall = true;
      };
      spaghetti-kart-git.enable = true;
      starship-sf64.enable = true;
    };

    security = {
      pam = {
        loginLimits = [
          # RPCS3
          {
            domain = "*";
            type = "hard";
            item = "memlock";
            value = "unlimited";
          }
          # RPCS3
          {
            domain = "*";
            type = "soft";
            item = "memlock";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "nofile";
            type = "-";
            value = "2097152";
          }
          {
            domain = "*";
            item = "nofile";
            type = "soft";
            value = "64556";
          }
        ];
      };
    };

    services = {
      ananicy = {
        enable = false;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
      hardware = {
        openrgb = {
          enable = false;
          package = pkgs.openrgb-with-all-plugins;
        };
      };
      input-remapper = {
        enable = false;
      };
      lsfg-vk = {
        enable = true;
        ui.enable = true;
      };
      scx = {
        enable = true;
        package = pkgs.scx.rustscheds;
        scheduler = "scx_lavd";
        extraArgs = [
          "--autopower"
        ];
      };
      udev = {
        extraHwdb =
          with builtins;
          concatStringsSep "\n" (
            with inputs;
            map readFile [
              "${simracing-hwdb}/90-cammus.hwdb"
              "${simracing-hwdb}/90-fanatec.hwdb"
              "${simracing-hwdb}/90-heusinkveld.hwdb"
              "${simracing-hwdb}/90-leo-bodnar.hwdb"
              "${simracing-hwdb}/90-mmos.hwdb"
              "${simracing-hwdb}/90-oddor.hwdb"
              "${simracing-hwdb}/90-shh.hwdb"
              "${simracing-hwdb}/90-simagic.hwdb"
              "${simracing-hwdb}/90-simgrade.hwdb"
              "${simracing-hwdb}/90-simjack.hwdb"
              "${simracing-hwdb}/90-simlab.hwdb"
              "${simracing-hwdb}/90-simruito.hwdb"
              "${simracing-hwdb}/90-simsonn.hwdb"
              "${simracing-hwdb}/90-simtrecs.hwdb"
              "${simracing-hwdb}/90-thrustmaster.hwdb"
              "${simracing-hwdb}/90-vrs.hwdb"
            ]
          );
        packages = import ./udev.nix { inherit pkgs inputs; };
      };
    };

    systemd = {
      settings.Manager = {
        # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/systemd/system.conf.d/10-limits.conf
        DefaultLimitNOFILE = "2048:2097152";
      };
    };

    home-manager.users.${username} =
      {
        inputs,
        config,
        osConfig,
        lib,
        ...
      }:
      {
        home = {
          file = import ./files.nix {
            inherit
              pkgs
              inputs
              config
              osConfig
              ;
          };
          packages =
            with lib;
            flatten (
              attrValues (
                import ./packages.nix {
                  inherit
                    pkgs
                    inputs
                    config
                    ;
                }
              )
            );
          sessionVariables = {
            RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
            RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
            # https://wiki.cachyos.org/configuration/gaming/#increase-maximum-shader-cache-size
            AMD_VULKAN_ICD = "RADV";
            MESA_SHADER_CACHE_MAX_SIZE = "12G";
            # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
            MESA_VK_WSI_PRESENT_MODE = "fifo";
            SDL_VIDEODRIVER = "wayland,x11"; # SDL2
            SDL_VIDEO_DRIVER = "wayland,x11"; # SDL3
          };
        };

        programs = {
          prismlauncher.enable = true;
        };

        services = {
          flatpak = import ./flatpaks.nix { inherit config; };
          ludusavi = import ./ludusavi.nix { inherit config; };
          wayland-pipewire-idle-inhibit = {
            enable = true;
            settings = {
              verbosity = "WARN";
              media_minimum_duration = 5;
              idle_inhibitor = "d-bus";
              sink_whitelist = [
                { name = "Browser"; }
                { name = "Game"; }
                { name = "Music"; }
              ];
            };
          };
        };
        systemd.user.timers.ludusavi = lib.mkForce {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnBootSec = "2min";
            OnUnitActiveSec = "24h";
          };
        };
        xdg = {
          autostart.entries = with pkgs; [
            "${nuked-sc55}/share/applications/Nuked-SC55_silent.desktop"
          ];
          desktopEntries = import ./desktop-entries.nix { inherit pkgs config lib; };
        };
      };
  };
}
