{
  flake.modules.homeManager.profile-gaming =
    { lib, pkgs, ... }:
    let
      launch = pkgs.writeShellApplication {
        name = "nuked-sc55-launch";
        runtimeEnv = {
          PIPEWIRE_NODE = "MIDI";
          PULSE_SINK = "MIDI";
          SDL_APP_NAME = "Nuked";
        };
        text = ''
          exec ${lib.getExe pkgs.local.nuked-sc55} --no-lcd --romset mk1-v1.21 "$@"
        '';
      };
    in
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "nuked-sc55-toggle";
          runtimeInputs = [ pkgs.procps ];
          text = ''
            pkill -x nuked-sc55 || exec ${lib.getExe launch}
          '';
        })
        pkgs.local.nuked-sc55
      ];
      xdg.desktopEntries.nuked-sc55 = {
        categories = [
          "Audio"
          "AudioVideo"
        ];
        comment = "Roland SC-55 MIDI emulator";
        exec = lib.getExe launch;
        icon = "pianoteq";
        name = "Nuked SC-55";
        terminal = false;
      };
    };
}
