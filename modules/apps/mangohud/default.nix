{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.mangohud;
  cpu = if config.networking.hostName == "nixos-desktop" then "7950X3D" else "";
  gpu = if config.networking.hostName == "nixos-desktop" then "7900XTX" else "";
in
{
  options = {
    mangohud = {
      enable = lib.mkEnableOption "Enable mangohud in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        home.file = {
          # https://gitlab.freedesktop.org/drm/amd/-/issues/3166#note_2277578
          # https://reddit.com/r/linux_gaming/comments/1kz7kkv/is_nvidia_holding_me_back_on_linux/mv3625m/#mv3625m
          mangohud-config = {
            enable = true;
            text = ''
              ###############
              ##  Display  ##
              ###############
              gl_vsync=1
              vsync=2
              fps_limit=352,240,120,60,30,0

              ###########
              ## Binds ##
              ###########
              toggle_fps_limit=Shift_R+F1
              toggle_hud=Alt_R+Shift_R
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
              custom_text=VRR
              exec=if (${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor --outputs | ${pkgs.ripgrep}/bin/rg Vrr | ${pkgs.coreutils}/bin/head -1 | ${pkgs.ripgrep}/bin/rg -q Automatic); then echo "Yes"; else echo "No"; fi
              custom_text=P-State
              exec=echo $(${pkgs.bat}/bin/bat --plain /sys/devices/system/cpu/amd_pstate/status /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)
              custom_text=V-Cache
              exec=echo $(${pkgs.bat}/bin/bat --plain /sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode)
              custom_text=OS
              exec=${pkgs.ripgrep}/bin/rg -w PRETTY_NAME /etc/os-release | ${pkgs.coreutils}/bin/cut -d '=' -f2 | ${pkgs.coreutils}/bin/tr -d '"'
              custom_text=Distrobox
              exec=${pkgs.bash}/bin/bash -c '[ -n "''${CONTAINER_ID}" ] && echo Yes || echo No'
              custom_text=Kernel
              exec=${pkgs.coreutils}/bin/uname -r

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
              font_file=${pkgs.atkinson-hyperlegible-next}/share/fonts/opentype/AtkinsonHyperlegibleNext-Bold.otf
              font_size=30
              ${lib.optionalString config.catppuccin.enable ''
                # Catppuccin theming
                background_color=1e1e2e
                battery_color=585b70
                cpu_color=89b4fa
                cpu_load_color=a6e3a1,f9e2af,f38ba8
                engine_color=cba6f7
                fps_color=f38ba8,f9e2af,a6e3a1
                frametime_color=a6e3a1
                gpu_color=cba6f7
                gpu_load_color=a6e3a1,f9e2af,f38ba8
                io_color=f9e2af
                media_player_color=cdd6f4
                ram_color=94e2d5
                text_color=cdd6f4
                text_outline_color=1e1e2e
                vram_color=94e2d5
                wine_color=cba6f7
              ''}'';
            target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
          };
          mangohud-presets = {
            enable = true;
            text = '''';
            target = "${config.xdg.configHome}/MangoHud/presets.conf";
          };
        };
        programs.mangohud = {
          enable = true;
          package = inputs.chaotic.packages.${pkgs.system}.mangohud_git;
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
          ];
        };
      };
  };
}
