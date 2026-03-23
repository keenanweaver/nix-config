{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.mangohud;
  hostHardware = {
    nixos-desktop = {
      cpu = "7950X3D";
      gpu = "7900XTX";
      primaryMonitor = "DP-1";
    };
  };
  currentHost =
    hostHardware.${config.networking.hostName} or {
      cpu = "";
      gpu = "";
      primaryMonitor = "";
    };
  cpu = currentHost.cpu;
  gpu = currentHost.gpu;
  primaryMonitor = currentHost.primaryMonitor;
in
{
  options = {
    mangohud = {
      enable = lib.mkEnableOption "Enable mangohud in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        config,
        pkgs,
        ...
      }:
      let
        mangohud-hdr = pkgs.writeShellApplication {
          name = "mangohud-hdr";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
            jq
          ];
          text = ''
            if kscreen-doctor --json | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .hdr' | grep -q "true"; then
              echo "Enabled"
            else
              echo "Disabled"
            fi
          '';
        };
        mangohud-wcg = pkgs.writeShellApplication {
          name = "mangohud-wcg";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
            jq
          ];
          text = ''
            if kscreen-doctor --json | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .wcg' | grep -q "true"; then
              echo "Enabled"
            else
              echo "Disabled"
            fi
          '';
        };
        mangohud-vrr = pkgs.writeShellApplication {
          name = "mangohud-vrr";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
            jq
          ];
          text = ''
            if kscreen-doctor --json | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .vrrPolicy != 0' | grep -q "true"; then
              echo "Enabled"
            else
              echo "Disabled"
            fi
          '';
        };
        mangohud-pstate = pkgs.writeShellApplication {
          name = "mangohud-pstate";
          runtimeInputs = with pkgs; [ bat ];
          text = ''
            bat --plain \
              /sys/devices/system/cpu/amd_pstate/status \
              /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference
          '';
        };
        mangohud-vcache = pkgs.writeShellApplication {
          name = "mangohud-vcache";
          runtimeInputs = with pkgs; [ bat ];
          text = ''
            bat --plain /sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode
          '';
        };
        mangohud-os = pkgs.writeShellApplication {
          name = "mangohud-os";
          runtimeInputs = with pkgs; [ ripgrep ];
          text = ''
            (rg -Nw PRETTY_NAME /run/host/etc/os-release 2>/dev/null \
              || rg -Nw PRETTY_NAME /run/current-system/etc/os-release 2>/dev/null \
              || rg -Nw PRETTY_NAME /etc/os-release) \
              | cut -d= -f2 | tr -d '"'
          '';
        };
        mangohud-runtime = pkgs.writeShellApplication {
          name = "mangohud-runtime";
          runtimeInputs = with pkgs; [ ripgrep ];
          text = ''
            if [ -n "''${CONTAINER_ID:-}" ]; then
              echo "[Distrobox] ''${CONTAINER_ID}"
            elif [ -n "''${FLATPAK_ID:-}" ]; then
              echo "[Flatpak] ''${FLATPAK_ID}"
            elif rg -Nw PRETTY_NAME /etc/os-release | rg -q "Steam Runtime"; then
              rg -Nw PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
            else
              echo "Native"
            fi
          '';
        };
        mangohud-kernel = pkgs.writeShellApplication {
          name = "mangohud-kernel";
          runtimeInputs = with pkgs; [ coreutils ];
          text = ''
            uname -r
          '';
        };
      in
      {
        home.file = {
          # https://gitlab.freedesktop.org/drm/amd/-/issues/3166#note_2277578
          # https://reddit.com/r/linux_gaming/comments/1kz7kkv/is_nvidia_holding_me_back_on_linux/mv3625m/#mv3625m
          # https://github.com/doitsujin/dxvk/issues/5330
          # https://www.reddit.com/r/nvidia/comments/1lokih2/putting_misconceptions_about_optimal_fps_caps/
          # https://reddit.com/r/linux_gaming/comments/1qh9r6z/so_confused_about_vsync_cachyos_mangohud/o0ihhi1/?context=3#o0ihhi1 Early breaks VRR
          mangohud-config = {
            enable = true;
            text = with pkgs; ''
              ###############
              ##  Display  ##
              ###############
              fps_limit=328,0,240,120,60,30
              fps_limit_method=early
              vsync=1
              gl_vsync=0

              ###########
              ## Binds ##
              ###########
              toggle_fps_limit=Shift_R+F1
              toggle_hud=Shift_L+Shift_R
              toggle_hud_position=Shift_R+F11
              toggle_preset=Shift_R+F10

              #########
              ## GPU ##
              #########
              pci_dev=0000:03:00.0
              fps
              fps_color_change
              fps_metrics=avg,0.01
              fps_value=30,60
              frame_timing
              frame_timing_detailed
              gpu_stats
              gpu_temp
              gpu_core_clock
              gpu_power
              gpu_power_limit
              gpu_load_change
              gpu_load_value=60,90
              gpu_fan
              gpu_voltage
              gpu_text=${gpu}
              throttling_status_graph

              #########
              ## CPU ##
              #########
              cpu_stats
              cpu_temp
              cpu_power
              cpu_mhz
              cpu_text=${cpu}
              cpu_load_change
              cpu_load_value=50,90
              core_load_change
              core_load
              core_bars

              #########
              ## RAM ##
              #########
              vram
              proc_vram
              gpu_mem_temp
              swap
              ram
              procmem

              ##########
              ## Info ##
              ##########
              exec_name
              arch
              vulkan_driver
              # dx_api
              wine
              winesync
              gamemode
              vkbasalt
              fsr
              hdr
              refresh_rate
              show_fps_limit
              resolution
              present_mode
              display_server # Doesn't work when legacy_layout=0

              ############
              ## Custom ##
              ############
              custom_text=HDR
              exec=${lib.getExe mangohud-hdr}
              custom_text=WCG
              exec=${lib.getExe mangohud-wcg}
              custom_text=VRR
              exec=${lib.getExe mangohud-vrr}
              custom_text=P-State
              exec=${lib.getExe mangohud-pstate}
              custom_text=V-Cache
              exec=${lib.getExe mangohud-vcache}
              custom_text=OS
              exec=${lib.getExe mangohud-os}
              custom_text=Runtime
              exec=${lib.getExe mangohud-runtime}
              custom_text=Kernel
              exec=${lib.getExe mangohud-kernel}

              ########
              ## UI ##
              ########
              text_outline
              text_outline_thickness=2.0
              position=bottom-right
              background_alpha=0.5
              round_corners=10
              no_display
              legacy_layout=0 # For scripts that rely on the new layout
              font_file=${atkinson-hyperlegible-next}/share/fonts/opentype/AtkinsonHyperlegibleNext-Bold.otf
              font_size=30
              width=450
              height=450
              ${lib.optionalString config.catppuccin.enable ''
                # Catppuccin theming
                background_color=1E1E2E
                battery_color=585b70
                cpu_color=89B4FA
                cpu_load_color=CDD6F4,FAB387,F38BA8
                engine_color=b4befe
                fps_color=F38BA8,F9E2AF,A6E3A1
                frametime_color=a6e3a1
                gpu_color=A6E3A1
                gpu_load_color=CDD6F4,FAB387,F38BA8
                io_color=F9E2AF
                media_player_color=CDD6F4
                ram_color=F5C2E7
                text_color=cdd6f4
                text_outline_color=11111b
                vram_color=94e2d5
                wine_color=b4befe
              ''}'';
            target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
          };
          mangohud-presets = {
            enable = true;
            text = "";
            target = "${config.xdg.configHome}/MangoHud/presets.conf";
          };
        };
        programs.mangohud = {
          enable = true;
        };
        services.flatpak = {
          overrides = {
            global = {
              Context = {
                filesystems = [
                  "xdg-config/MangoHud:ro"
                ];
              };
            };
          };
          packages = [
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
          ];
        };
      };
  };
}
