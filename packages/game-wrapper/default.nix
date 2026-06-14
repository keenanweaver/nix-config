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
    DEFAULT_EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa-git}/share/glvnd/egl_vendor.d/50_mesa.json";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    if [[ -z "''${MESA_LOADER_DRIVER_OVERRIDE+x}" ]]; then
      export MESA_LOADER_DRIVER_OVERRIDE="$DEFAULT_MESA_LOADER"
      export GALLIUM_DRIVER="$DEFAULT_GALLIUM_DRIVER"
      export __GLX_VENDOR_LIBRARY_NAME="$DEFAULT_GLX_VENDOR_LIBRARY_NAME"
      export __EGL_VENDOR_LIBRARY_FILENAMES="$DEFAULT_EGL_VENDOR_LIBRARY_FILENAMES"
      exec env gamemoderun mangohud "$@"
    elif [[ -z "$MESA_LOADER_DRIVER_OVERRIDE" ]]; then
      unset MESA_LOADER_DRIVER_OVERRIDE
      unset GALLIUM_DRIVER
      unset __GLX_VENDOR_LIBRARY_NAME
      unset __EGL_VENDOR_LIBRARY_FILENAMES
      unset OBS_VKCAPTURE
      exec env gamemoderun obs-gamecapture mangohud "$@"
    else
      exec env gamemoderun mangohud "$@"
    fi
  '';
}
