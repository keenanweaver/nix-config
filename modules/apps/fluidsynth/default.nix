{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.fluidsynth;
  soundfont = "SC-55 SoundFont.v1.2b [Trevor0402].sf2";
in
{
  options.fluidsynth = {
    enable = lib.mkEnableOption "Enable Fluidsynth in home-manager";
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "-g 1.0" ];
    };
    soundFont = lib.mkOption {
      type = lib.types.path;
      default = "/home/${username}/Music/soundfonts/default.sf2";
    };
    soundService = lib.mkOption {
      type = lib.types.enum [
        "jack"
        "pipewire-pulse"
        "pulseaudio"
      ];
      default = "pipewire-pulse";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { inputs, config, ... }:
      {
        home.file = {
          midi-soundfonts-default = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/soundfonts/${soundfont}";
            target = "Music/soundfonts/default.sf2";
          };
          midi-soundfonts-default-dosbox = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/soundfonts/${soundfont}";
            target = "${config.xdg.configHome}/dosbox/soundfonts/default.sf2";
          };
        };
        home.sessionVariables = {
          SDL_SOUNDFONTS = "${cfg.soundFont}";
        };
        services.fluidsynth = {
          enable = false;
          extraOptions = cfg.extraOptions;
          soundFont = cfg.soundFont;
          soundService = cfg.soundService;
        };
        xdg.autostart.entries =
          let
            desktopEntry = (
              pkgs.makeDesktopItem {
                name = "fluidsynth";
                desktopName = "fluidsynth";
                exec = "${pkgs.fluidsynth}/bin/fluidsynth -a pulseaudio -siq -g 1.0 ${config.home.homeDirectory}/Music/soundfonts/default.sf2";
                comment = "Run fluidsynth with my options";
                terminal = false;
                startupNotify = false;
              }
            );
          in
          lib.mkIf cfg.autostart [
            "${desktopEntry}/share/applications/${desktopEntry.name}"
          ];
      };
  };
}
