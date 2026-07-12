{
  flake.modules.homeManager.gaming-profile =
    {
      config,
      pkgs,
      inputs,
      osConfig,
      ...
    }:
    {
      home.file =
        let
          inherit (osConfig.host)
            primaryMonitor
            ;
        in
        {
          dosbox-roms-mt32 = {
            enable = true;
            source = "${inputs.nonfree}/Music/roland/mt32";
            target = "${config.xdg.configHome}/dosbox/mt32-roms";
          };
          dosbox-roms-sc55 = {
            enable = true;
            source = "${inputs.nonfree}/Music/roland/sc55";
            target = "${config.xdg.configHome}/dosbox/soundcanvas-roms";
          };
          dosbox-soundfont = {
            enable = true;
            source = config.services.fluidsynth.soundFont;
            target = "${config.xdg.configHome}/dosbox/soundfonts/default.sf2";
          };
          toggle-hdr = {
            enable = true;
            source =
              with pkgs;
              lib.getExe (writeShellApplication {
                name = "toggle-hdr";
                runtimeInputs = [
                  kdePackages.libkscreen
                  jq
                ];
                text = ''
                  hdr_status=$(kscreen-doctor --json | jq -r --arg s "${primaryMonitor}" '.outputs[] | select(.name == $s) | .hdr')
                  if [ "$hdr_status" = "false" ]; then
                    kscreen-doctor "output.${primaryMonitor}.hdr.enable"
                    kscreen-doctor "output.${primaryMonitor}.wcg.enable"
                  elif [ "$hdr_status" = "true" ]; then
                    kscreen-doctor "output.${primaryMonitor}.hdr.disable"
                    kscreen-doctor "output.${primaryMonitor}.wcg.disable"
                    kscreen-doctor "output.${primaryMonitor}.wcg.enable"
                  fi
                '';
              });
            target = "${config.home.homeDirectory}/Games/toggle-hdr.sh";
          };
          toggle-vrr = {
            enable = true;
            source =
              with pkgs;
              lib.getExe (writeShellApplication {
                name = "toggle-vrr";
                runtimeInputs = [
                  kdePackages.libkscreen
                  jq
                ];
                text = ''
                  vrr_policy=$(kscreen-doctor --json | jq -r --arg s "${primaryMonitor}" '.outputs[] | select(.name == $s) | .vrrPolicy')
                  if [ "$vrr_policy" = "0" ]; then
                    kscreen-doctor "output.${primaryMonitor}.vrrpolicy.automatic"
                  else
                    kscreen-doctor "output.${primaryMonitor}.vrrpolicy.never"
                  fi
                '';
              });
            target = "${config.home.homeDirectory}/Games/toggle-vrr.sh";
          };
        };
    };
}
