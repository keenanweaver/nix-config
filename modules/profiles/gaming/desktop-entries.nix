{
  pkgs,
  config,
  lib,
  ...
}:
let
  audioCapture = "env PIPEWIRE_NODE=Game PULSE_SINK=Game ";
  mangohud = lib.getExe' pkgs.mangohud "mangohud" + " ";
  videoCapture = lib.getExe' pkgs.obs-studio-plugins.obs-vkcapture "obs-gamecapture" + " ";
  avm = audioCapture + videoCapture + mangohud;
in
{
  doomrunner = {
    name = "Doom Runner";
    comment = "Preset-oriented graphical launcher of various ported Doom engines";
    exec = avm + (lib.getExe pkgs.doomrunner);
    icon = "DoomRunner";
    categories = [ "Game" ];
    noDisplay = false;
    startupNotify = true;
    terminal = false;
  };
  dreamm =
    let
      execBin = "${config.home.homeDirectory}/Games/dreamm/dreamm";
    in
    {
      name = "DREAMM";
      comment = "Specialized emulator for playing many of your original DOS, Windows, and FM-Towns LucasArts (and LucasArts-adjacent) games";
      exec = avm + execBin;
      icon = "${config.home.homeDirectory}/Games/dreamm/dreamm.png";
      noDisplay = false;
      startupNotify = true;
      terminal = false;
    };
  easyrpg-player =
    let
      execBin = lib.getExe' pkgs.easyrpg-player "easyrpg-player";
      execArgs = " --project-path ${config.home.homeDirectory}/Games/rpg-maker";
    in
    {
      name = "EasyRPG Player";
      comment = "Play RPG Maker games";
      exec = avm + execBin + execArgs;
      icon = "easyrpg-player";
      categories = [
        "Game"
        "RolePlaying"
      ];
      settings = {
        StartupWMClass = "EasyRPG Player";
      };
      startupNotify = true;
      terminal = false;
    };
  gog-galaxy =
    let
      icon = pkgs.fetchurl {
        url = "https://docs.gog.com/_assets/galaxy_icon_rgb.svg";
        hash = "sha256-SpaFaSK05Uq534qPYV7s7/vzexZmMnpJiVtOsbCtjvg=";
      };
    in
    {
      name = "GOG Galaxy";
      comment = "Launch GOG Galaxy using nero-umu";
      exec = (lib.getExe pkgs.nero-umu) + " --prefix \"GOG Galaxy\" --shortcut \"GOG Galaxy\"";
      icon = "${icon}";
      categories = [ "Game" ];
      noDisplay = false;
      startupNotify = true;
      settings = {
        StartupWMClass = "GOG Galaxy";
      };
    };
  nero-umu = {
    name = "Nero UMU";
    comment = "A fast and efficient umu manager, just as the Romans designed";
    exec =
      audioCapture + "PROTON_USE_NTSYNC=1 PROTON_FSR4_RDNA3_UPGRADE=1 " + (lib.getExe pkgs.nero-umu);
    icon = "xyz.TOS.Nero";
    categories = [ "Game" ];
    mimeType = [
      "application/x-ms-dos-executable"
      "application/x-msi"
      "application/x-bat"
    ];
    noDisplay = false;
    startupNotify = true;
    terminal = false;
  };
  quake-injector = {
    name = "Quake Injector";
    exec = lib.getExe (
      pkgs.writeShellApplication {
        name = "quake-injector";
        runtimeEnv = {
          quakeDir = "${config.home.homeDirectory}/Games/quake/quake-1/injector";
          exec = "${audioCapture} obs-gamecapture mangohud quake-injector";
        };
        runtimeInputs = with pkgs; [
          mangohud
          obs-studio-plugins.obs-vkcapture
          quake-injector
        ];
        text = ''
          pushd $quakeDir
          $exec
          popd
        '';
      }
    );
    icon = "quake-injector";
    categories = [ "Game" ];
    settings = {
      Path = "${config.home.homeDirectory}/Games/quake/quake-1/injector";
    };
  };
  scummvm = {
    name = "ScummVM";
    comment = "Interpreter for numerous adventure games and RPGs";
    exec = avm + (lib.getExe pkgs.scummvm);
    icon = "org.scummvm.scummvm";
    categories = [
      "Game"
      "AdventureGame"
      "RolePlaying"
    ];
    noDisplay = false;
    settings = {
      StartupWMClass = "scummvm";
    };
    startupNotify = false;
    terminal = false;
  };
  sonic-1 =
    let
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/24b16fede9a67c9251d3e7c7161c83ac.png";
        hash = "sha256-m5CEGaJj4Pr37EZIQpsHyBGYYjI9P2vNAOIBI2N5iiY=";
      };
    in
    {
      name = "Sonic the Hedgehog";
      exec = avm + (lib.getExe pkgs.rsdkv4);
      inherit icon;
      categories = [
        "Game"
      ];
      noDisplay = false;
      settings = {
        Path = "${config.home.homeDirectory}/Games/sonic/sonic-1";
      };
      startupNotify = false;
      terminal = false;
    };
  sonic-2 =
    let
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/6b180037abbebea991d8b1232f8a8ca9/32/256x256.png";
        hash = "sha256-dU0Kz8UhHnj7H9/2psCKvJ6ssvqiJQHHl2CZRNgFkjo=";
      };
    in
    {
      name = "Sonic the Hedgehog 2";
      exec = avm + (lib.getExe pkgs.rsdkv4);
      inherit icon;
      categories = [
        "Game"
      ];
      noDisplay = false;
      settings = {
        Path = "${config.home.homeDirectory}/Games/sonic/sonic-2";
      };
      startupNotify = false;
      terminal = false;
    };
  sonic-cd =
    let
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/f416d0fbce436dde50730df3a12bba3b/24/256x256.png";
        hash = "sha256-ZsZDjMCB2H3zkyTm42KfHVPPT/GwswVPa7NxPcqcz6Q=";
      };
    in
    {
      name = "Sonic CD";
      exec = avm + (lib.getExe pkgs.rsdkv3);
      inherit icon;
      categories = [
        "Game"
      ];
      noDisplay = false;
      settings = {
        Path = "${config.home.homeDirectory}/Games/sonic/sonic-cd";
      };
      startupNotify = false;
      terminal = false;
    };
}
