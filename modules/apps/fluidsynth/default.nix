{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.fluidsynth;
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
      default = "${pkgs.soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2";
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
      { config, ... }:
      {
        home.file = {
          midi-soundfonts-default = {
            enable = true;
            source = cfg.soundFont;
            target = "${config.home.homeDirectory}/Music/soundfonts/default.sf2";
          };
        };
        home.sessionVariables = {
          SDL_SOUNDFONTS = "${cfg.soundFont}";
        };
        services.fluidsynth = {
          enable = true;
          extraOptions = cfg.extraOptions;
          soundFont = cfg.soundFont;
          soundService = cfg.soundService;
        };
        systemd.user.services.fluidsynth = {
          Service = {
            Environment = [
              "PIPEWIRE_NODE=MIDI"
              "PULSE_SINK=MIDI"
            ];
          };
        };
      };
  };
}
