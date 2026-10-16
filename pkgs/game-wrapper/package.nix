{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";

  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];

  # On by default. GAME_WRAPPER optionally holds a comma-separated list of
  # options applied on top of the auto defaults.
  #
  #   GAME_WRAPPER unset / 1            auto (see below)
  #   GAME_WRAPPER=-mangohud,gl=native  auto, minus mangohud, no zink
  #   GAME_WRAPPER=0 / passthrough      run the command untouched
  #
  # Options:
  #   gl=zink|native         default zink: OpenGL goes to Vulkan, for Linux
  #                          and Windows games (DXVK/VKD3D are unaffected)
  #   mangohud / -mangohud   auto: on, off inside gamescope
  #   obs / -obs             auto: on, off inside gamescope
  #   gamemode / -gamemode   default on
  #   quiet                  don't print the summary line
  #   debug                  set -x
  #
  # zink-run https://wiki.cachyos.org/features/cachyos_settings/#zink-run
  text = ''
    if [[ "$#" -eq 0 ]]; then
      echo "game-wrapper: no command given" >&2
      echo "usage: game-wrapper <command> [args...]" >&2
      exit 64  # EX_USAGE
    fi

    spec="''${GAME_WRAPPER:-1}"
    if [[ "$spec" == 0 || "$spec" == passthrough ]]; then
      exec "$@"
    fi

    gl=zink
    mangohud=auto
    obs=auto
    gamemode=1
    quiet=0

    IFS=, read -ra opts <<< "$spec"
    for o in "''${opts[@]}"; do
      case "$o" in
        1 | auto) ;;
        passthrough) exec "$@" ;;
        mangohud | obs | gamemode) printf -v "$o" 1 ;;
        -mangohud | -obs | -gamemode) printf -v "''${o#-}" 0 ;;
        gl=zink | gl=native) gl="''${o#gl=}" ;;
        quiet) quiet=1 ;;
        debug) set -x ;;
        *)
          echo "game-wrapper: unknown GAME_WRAPPER option '$o'" >&2
          echo "expected: 1, passthrough, gl=zink|native, [-]mangohud, [-]obs, [-]gamemode, quiet, debug" >&2
          exit 64
          ;;
      esac
    done

    # Defaults that a game can still override.
    export PIPEWIRE_NODE="''${PIPEWIRE_NODE:-Game}"
    export PULSE_SINK="''${PULSE_SINK:-Game}"

    # --- context --------------------------------------------------------
    in_gamescope=false
    if [[ -n "''${GAMESCOPE_WAYLAND_DISPLAY:-}" || "''${XDG_CURRENT_DESKTOP:-}" == *gamescope* ]]; then
      in_gamescope=true
    fi

    compat_tool="''${STEAM_COMPAT_TOOL_PATHS:-}"
    compat_tool="''${compat_tool%%:*}"
    compat_tool="''${compat_tool##*/}"

    # --- resolve auto ---------------------------------------------------
    if [[ "$mangohud" == auto ]]; then
      if [[ "$in_gamescope" == true ]]; then mangohud=0; else mangohud=1; fi
    fi
    if [[ "$obs" == auto ]]; then
      if [[ "$in_gamescope" == true ]]; then obs=0; else obs=1; fi
    fi

    # --- apply ----------------------------------------------------------
    cmd=()

    if [[ "$gl" == zink ]]; then
      export MESA_LOADER_DRIVER_OVERRIDE=zink
      export GALLIUM_DRIVER=zink
    fi

    if [[ "$gamemode" == 1 ]]; then
      cmd+=(gamemoderun)
    fi

    if [[ "$obs" == 1 ]]; then
      if [[ "$gl" == zink ]]; then
        # GL goes through Vulkan under zink, so the Vulkan layer sees everything.
        export OBS_VKCAPTURE=1
      else
        # Vulkan layer + GL preload, 64- and 32-bit. The game may be started
        # by a 64-bit launcher, so preload both; ld.so skips the one whose
        # ELF class doesn't match.
        cmd+=(obs-gamecapture obs-gamecapture32)
      fi
    else
      unset OBS_VKCAPTURE
    fi

    if [[ "$mangohud" == 1 ]]; then
      cmd+=(mangohud)
    fi

    if [[ "$quiet" == 0 ]]; then
      echo "game-wrapper: gl=$gl mangohud=$mangohud obs=$obs gamemode=$gamemode" \
        "gamescope=$in_gamescope compat=''${compat_tool:-none}" >&2
    fi

    exec "''${cmd[@]}" "$@"
  '';
}
