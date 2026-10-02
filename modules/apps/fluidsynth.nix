{
  flake.modules.homeManager.profile-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.services.fluidsynth) soundFont;
    in
    {
      home = {
        file."Music/soundfonts/default.sf2".source = soundFont;
        sessionVariables.SDL_SOUNDFONTS = soundFont;
      };
      services.fluidsynth = {
        enable = true;
        soundFont = "${pkgs.soundfont-generaluser-gs}/share/soundfonts/GeneralUser-GS.sf2";
        soundService = "pipewire-pulse";
      };
      systemd.user.services.fluidsynth = {
        Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
        Service.Environment = [ "PULSE_SINK=MIDI" ];
        Unit.After = [ "graphical-session.target" ];
      };
    };
}
