{ pkgs }:
pkgs.writeShellApplication {
  name = "game-wrapper";
  runtimeEnv = {
    PIPEWIRE_NODE = "Game";
    PULSE_SINK = "Game";
    WINEDLLOVERRIDES = "dinput8,dxgi,dsound,ddraw=n,b";
  };
  runtimeInputs = with pkgs; [
    gamemode
    mangohud
    obs-studio-plugins.obs-vkcapture
  ];
  text = ''
    exec env gamemoderun obs-gamecapture mangohud "$@"
  '';
}
