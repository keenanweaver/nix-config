{
  flake.modules = {
    homeManager.profile-gaming =
      {
        lib,
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        home = {
          file = {
            mangohud-config =
              let
                inherit (osConfig.host)
                  cpu
                  cpuHasVcache
                  fpsLimit
                  gpu
                  pciDev
                  primaryMonitor
                  ;
                customEntries =
                  lib.optionals (primaryMonitor != "") [
                    {
                      command = mangohud-hdr;
                      label = "HDR";
                    }
                    {
                      command = mangohud-vrr;
                      label = "VRR";
                    }
                    {
                      command = mangohud-wcg;
                      label = "WCG";
                    }
                  ]
                  ++ [
                    {
                      command = mangohud-pstate;
                      label = "P-State";
                    }
                    {
                      command = mangohud-cpu-governor;
                      label = "Governor";
                    }
                  ]
                  ++ lib.optional cpuHasVcache {
                    command = mangohud-vcache;
                    label = "V-Cache";
                  }
                  ++ [
                    {
                      command = mangohud-scx;
                      label = "SCX";
                    }
                    {
                      command = mangohud-os;
                      label = "OS";
                    }
                    {
                      command = mangohud-runtime;
                      label = "Runtime";
                    }
                    {
                      command = mangohud-kernel;
                      label = "Kernel";
                    }
                  ];
                mangohud-cpu-governor = pkgs.writeShellApplication {
                  name = "mangohud-cpu-governor";
                  runtimeInputs = with pkgs; [ coreutils ];
                  text = ''
                    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "N/A"
                  '';
                };
                mangohud-hdr = pkgs.writeShellApplication {
                  name = "mangohud-hdr";
                  runtimeInputs = with pkgs; [
                    jq
                    ripgrep
                  ];
                  text = ''
                    if ${lib.getExe mangohud-kscreen-json} | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .hdr' | rg -q "true"; then
                      echo "Enabled"
                    else
                      echo "Disabled"
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
                mangohud-kscreen-json = pkgs.writeShellApplication {
                  name = "mangohud-kscreen-json";
                  runtimeInputs = with pkgs; [
                    coreutils
                    kdePackages.libkscreen
                  ];
                  text = ''
                    cache="''${XDG_RUNTIME_DIR:-/tmp}/mangohud-kscreen.json"
                    ttl=2

                    now=$(date +%s)
                    mtime=0
                    if [ -f "$cache" ]; then
                      mtime=$(stat -c %Y "$cache" 2>/dev/null || echo 0)
                    fi

                    if [ $((now - mtime)) -ge "$ttl" ]; then
                      kscreen-doctor --json > "$cache.tmp" 2>/dev/null && mv "$cache.tmp" "$cache" || true
                    fi

                    cat "$cache" 2>/dev/null || true
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
                mangohud-pstate = pkgs.writeShellApplication {
                  name = "mangohud-pstate";
                  runtimeInputs = with pkgs; [
                    coreutils
                    findutils
                  ];
                  text = ''
                    status="$(cat /sys/devices/system/cpu/amd_pstate/status 2>/dev/null || true)"
                    epp="$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || true)"
                    if [ -z "$status$epp" ]; then
                      echo "N/A"
                    else
                      echo "$status $epp" | xargs
                    fi
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
                mangohud-scx = pkgs.writeShellApplication {
                  name = "mangohud-scx";
                  runtimeInputs = with pkgs; [ coreutils ];
                  text = ''
                    if [ -f /sys/kernel/sched_ext/root/ops ]; then
                      cut -d_ -f1 < /sys/kernel/sched_ext/root/ops
                    else
                      echo "N/A"
                    fi
                  '';
                };
                mangohud-vcache = pkgs.writeShellApplication {
                  name = "mangohud-vcache";
                  runtimeInputs = with pkgs; [ coreutils ];
                  text = ''
                    cat /sys/bus/platform/drivers/amd_x3d_vcache/*/amd_x3d_mode 2>/dev/null || echo "N/A"
                  '';
                };
                mangohud-vrr = pkgs.writeShellApplication {
                  name = "mangohud-vrr";
                  runtimeInputs = with pkgs; [
                    jq
                    ripgrep
                  ];
                  text = ''
                    if ${lib.getExe mangohud-kscreen-json} | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .vrrPolicy != 0' | rg -q "true"; then
                      echo "Enabled"
                    else
                      echo "Disabled"
                    fi
                  '';
                };
                mangohud-wcg = pkgs.writeShellApplication {
                  name = "mangohud-wcg";
                  runtimeInputs = with pkgs; [
                    jq
                    ripgrep
                  ];
                  text = ''
                    if ${lib.getExe mangohud-kscreen-json} | jq -r '.outputs[] | select(.name == "${primaryMonitor}") | .wcg' | rg -q "true"; then
                      echo "Enabled"
                    else
                      echo "Disabled"
                    fi
                  '';
                };
              in
              {
                target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
                text = ''
                  fps
                  fps_metrics=avg,0.01,0.001
                  custom_text=  #space
                  frame_timing
                  gpu_stats

                  cpu_stats
                  core_load
                  custom_text=  #space

                  vram
                  ram
                  ram_temp
                  procmem_virt
                  procmem
                  procmem_shared

                  vulkan_driver
                  engine_version
                  arch
                  exec_name
                  present_mode
                  show_fps_limit
                  swap
                  gamemode
                  vkbasalt
                  fsr
                  hdr
                  refresh_rate
                  resolution
                  display_server
                  winesync
                  custom_text=  #space

                  ${lib.concatStringsSep "\n" (
                    map (entry: "custom_text=${entry.label}\nexec=${lib.getExe entry.command}") customEntries
                  )}

                  custom_text=  #space
                  wine

                  toggle_fps_limit=Shift_R+F1
                  toggle_hud=Shift_L+Shift_R
                  toggle_hud_position=Shift_R+F11
                  toggle_preset=Shift_R+F10

                  ${lib.optionalString (cpu != "") "cpu_text=${cpu}"}
                  ${lib.optionalString (pciDev != "") "pci_dev=${pciDev}"}
                  ${lib.optionalString (gpu != "") "gpu_text=${gpu}"}
                  ${lib.optionalString (fpsLimit != "") "fps_limit=${fpsLimit}"}

                  legacy_layout=false
                  gpu_load_change
                  gpu_core_clock
                  gpu_mem_clock
                  gpu_temp
                  gpu_mem_temp
                  gpu_junction_temp
                  gpu_fan
                  gpu_power
                  throttling_status_graph
                  cpu_load_change
                  core_bars
                  cpu_mhz
                  cpu_temp
                  cpu_power
                  cpu_efficiency
                  fps_color_change
                  hud_compact
                  gpu_power_limit

                  round_corners=1
                  background_alpha=0.5
                  position=bottom-right
                  no_display
                  table_columns=4
                  text_outline
                  text_outline_thickness=2.0
                  font_file=${pkgs.atkinson-hyperlegible-next}/share/fonts/opentype/AtkinsonHyperlegibleNext-Bold.otf
                  font_size=30
                  font_size_secondary=20
                  fps_value=30,60
                  gpu_load_value=60,90
                  cpu_load_value=60,90
                  fps_limit_method=late

                  ${lib.optionalString (config.catppuccin.enable or false) ''
                    background_color=1e1e2e
                    battery_color=585b70
                    cpu_color=89b3fa
                    cpu_load_color=a6e3a1,fab387,f38ba8
                    engine_color=b4befe
                    fps_color=f38ba7,f9e2af,a6e3a1
                    frametime_color=a6e3a1
                    gpu_color=a6e3a1
                    gpu_load_color=a6e3a1,fab387,f38ba8
                    horizontal_separator_color=cdd6f4
                    io_color=f9E2af
                    media_player_color=cdd6f4
                    network_color=b4befe
                    ram_color=f5c2e7
                    text_color=cdd6f4
                    text_outline_color=11111b
                    vram_color=94e2d5
                    wine_color=b4befe
                  ''}'';
              };
            mangohud-presets = {
              target = "${config.xdg.configHome}/MangoHud/presets.conf";
              text = "";
            };
          };
          packages = with pkgs; [
            mangojuice
          ];
        };
        programs.mangohud = {
          enable = true;
          package = pkgs.mangohud_git;
        };
        services.flatpak = {
          overrides.global.Context.filesystems = [
            "xdg-config/MangoHud:ro"
          ];
          packages = [
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/26.08"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
          ];
        };
      };
    nixos.profile-gaming = { config, ... }: {
      boot = {
        extraModulePackages = with config.boot.kernelPackages; [
          zenergy
        ];
        kernelModules = [
          "zenergy"
        ];
      };
    };
  };
}
