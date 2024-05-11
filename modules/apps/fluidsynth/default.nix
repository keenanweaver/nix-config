{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.fluidsynth;
  soundfont = "SC-55 SoundFont.v1.2b [Trevor0402].sf2";
in
{
  options.fluidsynth = {
    enable = lib.mkEnableOption "Enable Fluidsynth in home-manager";
    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "--gain 1.0" ];
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
          midi-soundfonts = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/soundfonts";
            target = "Music/soundfonts";
          };
          midi-soundfonts-default = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/soundfonts/${soundfont}";
            target = "Music/soundfonts/default.sf2";
          };
          midi-soundfonts-default-exodos = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/soundfonts/${soundfont}";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/dosbox/soundfonts/default.sf2";
          };
        };
        home.sessionVariables = {
          SDL_SOUNDFONTS = "/home/${username}/Music/soundfonts/default.sf2";
        };
        services.fluidsynth = {
          enable = true;
          extraOptions = cfg.extraOptions;
          soundFont = cfg.soundFont;
          soundService = cfg.soundService;
        };
      };
  };
}
