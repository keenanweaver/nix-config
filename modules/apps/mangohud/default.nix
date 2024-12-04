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
      { config, pkgs, ... }:
      {
        home.file = {
          mangohud-config = {
            enable = true;
            text = ''
              gpu_stats
              gpu_temp
              gpu_core_clock
              gpu_power
              gpu_load_change
              gpu_load_value=60,90
              gpu_fan
              gpu_voltage
              gpu_text=${gpu}
              cpu_stats
              cpu_temp
              cpu_power
              cpu_mhz
              cpu_text=${cpu}
              cpu_load_change
              cpu_load_value=60,90
              core_load_change
              vram
              ram
              swap
              procmem
              fps
              fps_color_change
              fps_limit=357,237,141,117,60,0
              toggle_fps_limit=Shift_R+F1
              fps_value=30,60
              frame_timing
              throttling_status_graph
              engine_version
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
              gl_vsync=1
              vsync=2 # https://gitlab.freedesktop.org/drm/amd/-/issues/3166#note_2277578
              custom_text=P-State
              exec=${pkgs.coreutils}/bin/cat /sys/devices/system/cpu/amd_pstate/status
              custom_text=P-State EPP
              exec=${pkgs.coreutils}/bin/cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference
              custom_text=OS
              exec=${pkgs.ripgrep}/bin/rg -w PRETTY_NAME /etc/os-release | ${pkgs.coreutils}/bin/cut -d '=' -f2 | ${pkgs.coreutils}/bin/tr -d '"'
              custom_text=Distrobox
              exec=${pkgs.bash}/bin/bash -c '[ -n "''${CONTAINER_ID}" ] && echo Yes || echo No'
              custom_text=Kernel
              exec=${pkgs.coreutils}/bin/uname -r
              text_outline
              text_outline_thickness=2.0
              position=bottom-right
              background_alpha=0.2
              round_corners=10
              no_display
              toggle_hud=Alt_R+End
              legacy_layout=0 # For scripts that rely on the new layout
              font_file=${pkgs.lexend}/share/fonts/truetype/lexend/lexend/Lexend-Bold.ttf
              ${lib.optionalString config.catppuccin.enable ''
                # Catppuccin theming
                background_color=1e1e2e
                battery_color=585b70
                cpu_color=89b4fa
                cpu_load_color=a6e3a1,f9e2af,f38ba8
                engine_color=cba6f7
                fps_color=f38ba8,f9e2af,a6e3a1
                frametime_color=a6e3a1
                gpu_color=a6e3a1
                gpu_load_color=a6e3a1,f9e2af,f38ba8
                io_color=f9e2af
                media_player_color=cdd6f4
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
          package = pkgs.mangohud_git; # Chaotic package
        };
      };
  };
}
