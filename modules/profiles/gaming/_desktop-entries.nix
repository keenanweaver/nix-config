{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  audioCapture = "env PIPEWIRE_NODE=Game PULSE_SINK=Game ";
  wrap = lib.getExe pkgs.local.game-wrapper + " ";
in
{
  easyrpg-player =
    let
      execArgs = " --project-path ${config.home.homeDirectory}/Games/rpg-maker";
      execBin = lib.getExe' pkgs.easyrpg-player "easyrpg-player";
    in
    {
      categories = [
        "Game"
        "RolePlaying"
      ];
      comment = "Play RPG Maker games";
      exec = wrap + execBin + execArgs;
      icon = "easyrpg-player";
      name = "EasyRPG Player [${osConfig.my.user}]";
      settings = {
        StartupWMClass = "EasyRPG Player";
      };
      startupNotify = true;
      terminal = false;
    };
  gog-galaxy =
    let
      icon = pkgs.fetchurl {
        hash = "sha256-SpaFaSK05Uq534qPYV7s7/vzexZmMnpJiVtOsbCtjvg=";
        url = "https://docs.gog.com/_assets/galaxy_icon_rgb.svg";
      };
    in
    {
      categories = [ "Game" ];
      comment = "Launch GOG Galaxy using nero-umu";
      exec = (lib.getExe pkgs.nero-umu) + " --prefix \"GOG Galaxy\" --shortcut \"GOG Galaxy\"";
      icon = "${icon}";
      name = "GOG Galaxy [${osConfig.my.user}]";
      noDisplay = false;
      settings = {
        StartupWMClass = "GOG Galaxy";
      };
      startupNotify = true;
    };
  nero-umu = {
    categories = [ "Game" ];
    comment = "A fast and efficient umu manager, just as the Romans designed";
    exec = audioCapture + "ENABLE_LSFG=1 " + (lib.getExe pkgs.nero-umu);
    icon = "xyz.TOS.Nero";
    mimeType = [
      "application/x-ms-dos-executable"
      "application/x-msi"
      "application/x-bat"
    ];
    name = "Nero-UMU [${osConfig.my.user}]";
    noDisplay = false;
    startupNotify = true;
    terminal = false;
  };
}
