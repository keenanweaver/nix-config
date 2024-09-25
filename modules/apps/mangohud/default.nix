{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.mangohud;
  cpu = if config.networking.hostName == "nixos-desktop" then "5800X" else "";
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
      let
        mangohud-get-vars = (
          pkgs.writeShellApplication {
            name = "mangohud-get-vars";
            runtimeInputs = with pkgs; [
              coreutils
              findutils
              glxinfo
              libnotify
              ripgrep
              util-linux
            ];
            text = ''
              # OS
              rg -w PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"' > ${config.xdg.configHome}/MangoHud/vars
              # Kernel
              uname -r >> ${config.xdg.configHome}/MangoHud/vars
              # CPU
              #lscpu | rg -oP '(?<=Model\sname:).*' | xargs >> ${config.xdg.configHome}/MangoHud/vars
              # GPU
              #glxinfo | rg -oP '(?<=Device: )(.*?)(?=\()' | xargs >> ${config.xdg.configHome}/MangoHud/vars
            '';
          }
        );
      in
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
              fps_value=30,60
              frametime
              engine_version
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
              custom_text=Distro
              exec=${pkgs.gnused}/bin/sed -n 1p ${config.xdg.configHome}/MangoHud/vars
              custom_text=Kernel
              exec=${pkgs.gnused}/bin/sed -n 2p ${config.xdg.configHome}/MangoHud/vars
              text_outline
              position=bottom-right
              no_display
              width=450
              background_alpha=0.5
              toggle_hud=Shift_R
              legacy_layout=0 # For scripts that rely on the old layout
              fps_sampling_period=1000
              font_file=${pkgs.atkinson-hyperlegible}/share/fonts/opentype/AtkinsonHyperlegible-Bold.otf
              ${lib.optionalString config.catppuccin.enable ''
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
              ''}'';
            target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
          };
          mangohud-presets = {
            enable = true;
            text = '''';
            target = "${config.xdg.configHome}/MangoHud/presets.conf";
          };
        };
        home.packages = with pkgs; [ mangohud-get-vars ];
        programs.mangohud = {
          enable = true;
          package = pkgs.mangohud_git; # Chaotic package
        };
        systemd = {
          user = {
            services = {
              "mangohud-get-vars" = {
                Unit = {
                  Description = "Writes variables for MangoHud config";
                };
                Service = {
                  ExecStart = "${mangohud-get-vars}/bin/mangohud-get-vars";
                  Type = "simple";
                };
                Install = {
                  WantedBy = [ "graphical-session.target" ];
                };
              };
            };
          };
        };
      };
  };
}
