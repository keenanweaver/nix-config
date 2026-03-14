{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    MESA_LOADER_DRIVER_OVERRIDE = "zink";
    OBS_VKCAPTURE = 1;
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
  ];
  text = ''
    export WINEDLLOVERRIDES="dinput8,dxgi,dsound,ddraw=n,b''${WINEDLLOVERRIDES:+;$WINEDLLOVERRIDES}"
    exec env gamemoderun mangohud "$@"
  '';
}
