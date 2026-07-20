{
  flake.modules.homeManager.gaming-profile = { pkgs, ... }: {
    home.packages = [ pkgs.local.nuked-sc55 ];
    /*
      xdg.autostart.entries = [
         (
           pkgs.makeDesktopItem {
             categories = [
               "Audio"
               "AudioVideo"
             ];
             comment = "Roland SC-55 MIDI emulator";
             desktopName = "Nuked SC-55 (autostart)";
             exec = "env PIPEWIRE_NODE=MIDI PULSE_SINK=MIDI SDL_APP_NAME=Nuked ${lib.getExe pkgs.local.nuked-sc55} --no-lcd --romset mk1-v1.21";
             name = "nuked-sc55-autostart";
             noDisplay = true;
             terminal = false;
           }
           + "/share/applications/nuked-sc55-autostart.desktop"
         )
       ];
    */
  };
}
