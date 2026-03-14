{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    OBS_VKCAPTURE = "1";
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
    DEFAULT_MESA_LOADER = "zink";
    DEFAULT_WINE_OVERRIDES = "dinput,dinput8,dxgi,dsound,ddraw";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    if [[ -z "''${WINEDLLOVERRIDES+x}" ]]; then
      export WINEDLLOVERRIDES="$DEFAULT_WINE_OVERRIDES=n,b"
    elif [[ -z "$WINEDLLOVERRIDES" ]]; then
      unset WINEDLLOVERRIDES
    else
      export WINEDLLOVERRIDES="$DEFAULT_WINE_OVERRIDES=n,b,$WINEDLLOVERRIDES"
    fi
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
