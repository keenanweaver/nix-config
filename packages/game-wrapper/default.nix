{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    OBS_VKCAPTURE = "1";
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
    DEFAULT_MESA_LOADER = "zink";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    if [[ -z "''${MESA_LOADER_DRIVER_OVERRIDE+x}" ]]; then
      export MESA_LOADER_DRIVER_OVERRIDE="$DEFAULT_MESA_LOADER"
      exec env gamemoderun mangohud "$@"
    elif [[ -z "$MESA_LOADER_DRIVER_OVERRIDE" ]]; then
      unset MESA_LOADER_DRIVER_OVERRIDE
      unset OBS_VKCAPTURE
      exec env gamemoderun obs-gamecapture mangohud "$@"
    else
      exec env gamemoderun mangohud "$@"
    fi
  '';
}