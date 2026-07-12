{
  flake.modules.homeManager.gaming-profile =
    { config, pkgs, ... }:
    let
      soundFont = "${pkgs.soundfont-generaluser-gs}/share/soundfonts/GeneralUser-GS.sf2";
    in
    {
      home = {
        file = {
          midi-soundfonts-default = {
            enable = true;
            source = soundFont;
            target = "${config.home.homeDirectory}/Music/soundfonts/default.sf2";
          };
        };
        sessionVariables = {
          SDL_SOUNDFONTS = soundFont;
        };
      };
      services.fluidsynth = {
        inherit soundFont;
        enable = true;
        soundService = "pipewire-pulse";
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
}
