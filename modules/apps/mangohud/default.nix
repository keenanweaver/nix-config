{
  lib,
  config,
  username,
  dotfiles,
  ...
}:
let
  cfg = config.mangohud;
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
          desktop-entry-mangohud-get-vars = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=${config.xdg.configHome}/MangoHud/get-vars.sh
              Icon=dialog-scripts
              Name=get-vars.sh
              Type=Application
              X-KDE-AutostartScript=true
            '';
            target = "${config.xdg.configHome}/autostart/get-vars.desktop";
          };
          mangohud-config = {
            enable = true;
            text =
              ''
                gpu_stats
                gpu_temp
                gpu_core_clock
                gpu_power
                gpu_load_change
                gpu_load_value=60,90
                gpu_fan
                gpu_voltage
                cpu_stats
                cpu_temp
                cpu_power
                cpu_mhz
                cpu_load_change
                cpu_load_value=60,90
                core_load_change
                vram
                ram
                swap
                procmem
                fps
                fps_color_change
                fps_value=30,60
                frametime
                engine_version
                gpu_name
                vulkan_driver
                wine
                winesync
                frame_timing
                histogram
                gamemode
                vkbasalt
                fsr
                hdr
                refresh_rate
                show_fps_limit
                resolution
                custom_text=Distro:
                exec=sed -n 1p ${config.xdg.configHome}/MangoHud/vars
                custom_text=Kernel:
                exec=sed -n 2p ${config.xdg.configHome}/MangoHud/vars
                text_outline
                position=bottom-right
                no_display
                width=450
                background_alpha=0.5
                toggle_hud=Shift_R
              ''
              ++ lib.optionalString config.catppuccinTheming.enable ''
                # Catppuccin theming
                background_color=1e1e2e
                battery_color=585b70
                cpu_color=89b4fa
                cpu_load_color=a6e3a1, f9e2af, f38ba8
                engine_color=cba6f7
                fps_color=a6e3a1, f9e2af, f38ba8
                frametime_color=a6e3a1
                gpu_color=a6e3a1
                gpu_load_color=a6e3a1, f9e2af, f38ba8
                io_color=f9e2af
                media_player_color=cdd6f4
                text_color=cdd6f4
                text_outline_color=1e1e2e
                vram_color=94e2d5
                wine_color=cba6f7
              '';
            target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
          };
          script-mangohud-get-vars = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              # OS
              grep -w PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"' > ${config.xdg.configHome}/MangoHud/vars
              # Kernel
              echo $(uname -r) >> ${config.xdg.configHome}/MangoHud/vars
              # CPU
              lscpu | grep -oP '(?<=Model\sname:).*' | xargs >> ${config.xdg.configHome}/MangoHud/vars
              # GPU
              glxinfo | grep -oP '(?<=Device: )(.*?)(?=\()' >> ${config.xdg.configHome}/MangoHud/vars
            '';
            target = "${config.xdg.configHome}/MangoHud/get-vars.sh";
            executable = true;
          };
        };
        programs.mangohud = {
          enable = true;
          package = pkgs.mangohud_git; # Chaotic package
        };
      };
    xdg.configFile."MangoHud/presets.conf".text = "";
  };
}
