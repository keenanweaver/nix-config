{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.fluidsynth;
  soundfont = "SC-55 SoundFont.v1.2b [Trevor0402].sf2";
in
{
  options.fluidsynth = {
    enable = mkEnableOption "Enable Fluidsynth in home-manager";
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ "--gain 1.0" ];
    };
    soundFont = mkOption {
      type = types.path;
      default = "/home/${username}/Music/soundfonts/default.sf2";
    };
    soundService = mkOption {
      type = types.enum [ "jack" "pipewire-pulse" "pulseaudio" ];
      default = "pipewire-pulse";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
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
      services.fluidsynth = {
        enable = true;
        extraOptions = cfg.extraOptions;
        soundFont = cfg.soundFont;
        soundService = cfg.soundService;
      };
    };
  };
}
