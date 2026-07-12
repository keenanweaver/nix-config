{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  wrap = lib.getExe pkgs.local.game-wrapper + " ";
in
{
  dreamm =
    let
      execBin = "${config.home.homeDirectory}/Games/dreamm/dreamm";
    in
    {
      categories = [
        "Game"
      ];
      comment = "Specialized emulator for playing many of your original DOS, Windows, and FM-Towns LucasArts (and LucasArts-adjacent) games";
      exec = wrap + execBin;
      icon = "${config.home.homeDirectory}/Games/dreamm/dreamm.png";
      name = "DREAMM [${osConfig.my.user}]";
      noDisplay = false;
      startupNotify = true;
      terminal = false;
    };
  scummvm = {
    categories = [
      "Game"
      "AdventureGame"
      "RolePlaying"
    ];
    comment = "Interpreter for numerous adventure games and RPGs";
    exec = wrap + (lib.getExe pkgs.scummvm);
    icon = "org.scummvm.scummvm";
    name = "ScummVM [${osConfig.my.user}]";
    noDisplay = false;
    settings = {
      StartupWMClass = "scummvm";
    };
    startupNotify = false;
    terminal = false;
  };
  sonic-cd =
    let
      icon = pkgs.fetchurl {
        hash = "sha256-ZsZDjMCB2H3zkyTm42KfHVPPT/GwswVPa7NxPcqcz6Q=";
        url = "https://cdn2.steamgriddb.com/icon/f416d0fbce436dde50730df3a12bba3b/24/256x256.png";
      };
    in
    {
      inherit icon;
      categories = [
        "Game"
      ];
      exec = wrap + (lib.getExe pkgs.local.rsdkv3);
      name = "Sonic CD [${osConfig.my.user}]";
      noDisplay = false;
      settings = {
        Path = "${config.home.homeDirectory}/Games/sonic/sonic-cd";
      };
      startupNotify = false;
      terminal = false;
    };
}
