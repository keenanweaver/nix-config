{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    export WINEDLLOVERRIDES="dinput8,dxgi,dsound,ddraw=n,b''${WINEDLLOVERRIDES:+,$WINEDLLOVERRIDES}"
    exec env gamemoderun obs-gamecapture mangohud "$@"
  '';
}
