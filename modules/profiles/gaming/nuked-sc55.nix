{
  flake.modules.homeManager.gaming-profile = { lib, pkgs, ... }: {
    home.packages = [ pkgs.local.nuked-sc55 ];

    xdg.desktopEntries.nuked-sc55 = {
      categories = [
        "Audio"
        "AudioVideo"
      ];
      comment = "Roland SC-55 MIDI emulator";
      exec = "env PIPEWIRE_NODE=MIDI PULSE_SINK=MIDI SDL_APP_NAME=Nuked ${lib.getExe pkgs.local.nuked-sc55} --no-lcd --romset mk1-v1.21";
      icon = "pianoteq";
      name = "Nuked SC-55";
      terminal = false;
    };
  };
}
