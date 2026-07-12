{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    LOW_LATENCY_LAYER = "1";
    OBS_VKCAPTURE = "1";
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
    # zink-run https://wiki.cachyos.org/features/cachyos_settings/#zink-run
    DEFAULT_MESA_LOADER = "zink";
    DEFAULT_GALLIUM_DRIVER = "zink";
    DEFAULT_GLX_VENDOR_LIBRARY_NAME = "mesa";
    DEFAULT_EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa_git}/share/glvnd/egl_vendor.d/50_mesa.json";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    #   zink        - force the zink GL stack + gamemode + mangohud  (default)
    #   obs         - native GL + gamemode + obs-gamecapture + mangohud
    #   native      - no driver forcing + gamemode + mangohud
    #   passthrough - run the command untouched (mod loaders, e.g. SRMM/Parless)
    mode="''${WRAPPER_MODE:-zink}"

    if [[ "$#" -eq 0 ]]; then
      echo "game-wrapper: no command given" >&2
      echo "usage: game-wrapper <command> [args...]" >&2
      exit 64  # EX_USAGE
    fi

    if [[ -n "''${WRAPPER_DEBUG:-}" ]]; then
      set -x
    fi

    if [[ "$mode" == "passthrough" ]]; then
      unset OBS_VKCAPTURE LOW_LATENCY_LAYER
      exec "$@"
    fi

    in_gamescope=false
    if [[ -n "''${GAMESCOPE_WAYLAND_DISPLAY:-}" || "''${XDG_CURRENT_DESKTOP:-}" == *gamescope* ]]; then
      in_gamescope=true
    fi

    cmd=(gamemoderun)
    want_mangohud=true
    want_obscapture=false

    case "$mode" in
      zink)
        export MESA_LOADER_DRIVER_OVERRIDE="$DEFAULT_MESA_LOADER"
        export GALLIUM_DRIVER="$DEFAULT_GALLIUM_DRIVER"
        export __GLX_VENDOR_LIBRARY_NAME="$DEFAULT_GLX_VENDOR_LIBRARY_NAME"
        export __EGL_VENDOR_LIBRARY_FILENAMES="$DEFAULT_EGL_VENDOR_LIBRARY_FILENAMES"
        ;;
      obs)
        unset OBS_VKCAPTURE
        want_obscapture=true
        ;;
      native)
        ;;
      *)
        echo "game-wrapper: unknown WRAPPER_MODE '$mode'" >&2
        echo "expected one of: zink, obs, native, passthrough" >&2
        exit 64
        ;;
    esac

    if [[ "$in_gamescope" == true ]]; then
      want_mangohud=false
      want_obscapture=false
      unset OBS_VKCAPTURE LOW_LATENCY_LAYER
    fi

    if [[ "$want_obscapture" == true ]]; then cmd+=(obs-gamecapture); fi
    if [[ "$want_mangohud"  == true ]]; then cmd+=(mangohud); fi

    exec "''${cmd[@]}" "$@"
  '';
}
