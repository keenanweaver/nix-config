{
  flake.modules.homeManager.profile-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      soundFont = "${pkgs.soundfont-generaluser-gs}/share/soundfonts/GeneralUser-GS.sf2";
    in
    {
      home = {
        file.midi-soundfonts-default = {
          source = soundFont;
          target = "${config.home.homeDirectory}/Music/soundfonts/default.sf2";
        };
        sessionVariables.SDL_SOUNDFONTS = soundFont;
      };
      services.fluidsynth = {
        inherit soundFont;
        enable = true;
        soundService = "pipewire-pulse";
      };
      systemd.user.services.fluidsynth.Service = {
        Environment = [
          "PIPEWIRE_NODE=MIDI"
          "PULSE_SINK=MIDI"
        ];
        ExecStart =
          let
            cfg = config.services.fluidsynth;
          in
          lib.mkForce "${lib.getExe cfg.package} -a pulseaudio -i ${lib.concatStringsSep " " cfg.extraOptions} ${cfg.soundFont}";
      };
    };
}
